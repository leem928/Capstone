import os
import re
import time
import secrets
import smtplib
from email.message import EmailMessage
from io import BytesIO
from pathlib import Path
from typing import Dict, Any, List, Tuple

from dotenv import load_dotenv
from fastapi import FastAPI, File, UploadFile, HTTPException, Form
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from PIL import Image, UnidentifiedImageError

import torch
import torch.nn as nn
from torchvision import transforms
from torchvision.models import convnext_tiny


# =========================
# 기본 설정
# =========================

load_dotenv()

app = FastAPI(title="Pet Skin AI Server")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "models" / "pet_skin_model.pth"

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")


# =========================
# 이메일 인증번호 설정
# =========================

SMTP_HOST = os.getenv("SMTP_HOST", "smtp.gmail.com")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_USERNAME = os.getenv("SMTP_USERNAME", "")
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD", "")
SMTP_FROM = os.getenv("SMTP_FROM", SMTP_USERNAME)

CODE_EXPIRE_SECONDS = 5 * 60
CODE_RESEND_LIMIT_SECONDS = 30

verification_codes: Dict[str, Dict[str, Any]] = {}


class EmailCodeRequest(BaseModel):
    email: str


class VerifyCodeRequest(BaseModel):
    email: str
    code: str


def normalize_email(email: str) -> str:
    return email.strip().lower()


def is_valid_email(email: str) -> bool:
    pattern = r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"
    return re.match(pattern, email) is not None


def generate_code() -> str:
    return str(secrets.randbelow(900000) + 100000)


def check_smtp_config() -> None:
    if not SMTP_USERNAME or not SMTP_PASSWORD or not SMTP_FROM:
        raise HTTPException(
            status_code=500,
            detail=(
                "SMTP 설정이 없습니다. "
                "pet_skin_server 폴더의 .env 파일에 "
                "SMTP_USERNAME, SMTP_PASSWORD, SMTP_FROM 값을 설정해주세요."
            ),
        )


def send_verification_email(email: str, code: str) -> None:
    check_smtp_config()

    subject = "[멍냥케어] 이메일 인증번호 안내"

    text_body = (
        "멍냥케어 회원가입 인증번호 안내\n\n"
        f"인증번호: {code}\n\n"
        "위 인증번호를 앱 화면에 입력하면 이메일 인증이 완료됩니다.\n"
        "인증번호는 5분 동안만 유효합니다.\n\n"
        "본인이 요청하지 않았다면 이 메일을 무시해주세요."
    )

    html_body = f"""
    <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <h2 style="color: #8B5E4B;">멍냥케어 이메일 인증번호</h2>
      <p>회원가입을 완료하려면 아래 인증번호를 앱 화면에 입력해주세요.</p>

      <div style="
        font-size: 32px;
        font-weight: bold;
        letter-spacing: 6px;
        color: #8B5E4B;
        background: #F8EFEA;
        padding: 18px;
        border-radius: 12px;
        text-align: center;
        margin: 20px 0;
      ">
        {code}
      </div>

      <p>인증번호는 <b>5분 동안</b>만 유효합니다.</p>
      <p>본인이 요청하지 않았다면 이 메일을 무시해주세요.</p>
    </div>
    """

    message = EmailMessage()
    message["Subject"] = subject
    message["From"] = SMTP_FROM
    message["To"] = email
    message.set_content(text_body)
    message.add_alternative(html_body, subtype="html")

    try:
        with smtplib.SMTP(SMTP_HOST, SMTP_PORT, timeout=15) as server:
            server.starttls()
            server.login(SMTP_USERNAME, SMTP_PASSWORD)
            server.send_message(message)
    except smtplib.SMTPAuthenticationError:
        raise HTTPException(
            status_code=500,
            detail=(
                "SMTP 로그인에 실패했습니다. "
                "Gmail 계정, 앱 비밀번호, 2단계 인증 설정을 확인해주세요."
            ),
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"이메일 발송 중 오류가 발생했습니다: {str(e)}",
        )


@app.post("/send-verification-code")
def send_verification_code(request: EmailCodeRequest):
    email = normalize_email(request.email)

    if not is_valid_email(email):
        raise HTTPException(
            status_code=400,
            detail="올바른 이메일 형식이 아닙니다.",
        )

    now = time.time()

    previous = verification_codes.get(email)
    if previous is not None:
        last_sent_at = previous.get("sent_at", 0)

        if now - last_sent_at < CODE_RESEND_LIMIT_SECONDS:
            remaining = int(CODE_RESEND_LIMIT_SECONDS - (now - last_sent_at))
            raise HTTPException(
                status_code=429,
                detail=f"인증번호는 {remaining}초 후 다시 요청할 수 있습니다.",
            )

    code = generate_code()

    send_verification_email(email, code)

    verification_codes[email] = {
        "code": code,
        "sent_at": now,
        "expires_at": now + CODE_EXPIRE_SECONDS,
        "verified": False,
    }

    print(f"[EMAIL VERIFICATION] {email} -> {code}")

    return {
        "success": True,
        "message": "인증번호를 이메일로 발송했습니다.",
        "expires_in_seconds": CODE_EXPIRE_SECONDS,
    }


@app.post("/verify-code")
def verify_code(request: VerifyCodeRequest):
    email = normalize_email(request.email)
    input_code = request.code.strip()

    if not is_valid_email(email):
        raise HTTPException(
            status_code=400,
            detail="올바른 이메일 형식이 아닙니다.",
        )

    if not re.match(r"^\d{6}$", input_code):
        raise HTTPException(
            status_code=400,
            detail="6자리 인증번호를 입력해주세요.",
        )

    record = verification_codes.get(email)

    if record is None:
        raise HTTPException(
            status_code=404,
            detail="인증번호 요청 기록이 없습니다. 인증번호를 다시 받아주세요.",
        )

    now = time.time()

    if now > record["expires_at"]:
        verification_codes.pop(email, None)
        raise HTTPException(
            status_code=400,
            detail="인증번호가 만료되었습니다. 다시 인증번호를 받아주세요.",
        )

    if input_code != record["code"]:
        raise HTTPException(
            status_code=400,
            detail="인증번호가 일치하지 않습니다.",
        )

    record["verified"] = True

    return {
        "success": True,
        "message": "이메일 인증이 완료되었습니다.",
        "email": email,
    }


@app.get("/verification-status")
def verification_status(email: str):
    normalized_email = normalize_email(email)
    record = verification_codes.get(normalized_email)

    if record is None:
        return {
            "email": normalized_email,
            "verified": False,
            "message": "인증 기록이 없습니다.",
        }

    if time.time() > record["expires_at"]:
        verification_codes.pop(normalized_email, None)
        return {
            "email": normalized_email,
            "verified": False,
            "message": "인증번호가 만료되었습니다.",
        }

    return {
        "email": normalized_email,
        "verified": bool(record.get("verified", False)),
    }


# =========================
# AI 모델 설정
# =========================

label_display_names = {
    "C_A2": "비듬·각질·상피성 잔고리 의심",
    "C_A4": "농포·여드름 의심",
    "C_A6": "결절·종괴 의심",

    "D_A1": "구진·플라크 의심",
    "D_A2": "비듬·각질·상피성 잔고리 의심",
    "D_A3": "태선화·과다색소침착 의심",
    "D_A4": "농포·여드름 의심",
    "D_A5": "미란·궤양 의심",
    "D_A6": "결절·종괴 의심",
}

label_descriptions = {
    "C_A2": "피부 표면에 비듬, 각질, 원형 잔고리 형태의 변화가 의심되는 상태입니다.",
    "C_A4": "피부에 농포 또는 여드름과 유사한 변화가 의심되는 상태입니다.",
    "C_A6": "피부에 결절이나 종괴처럼 만져지는 덩어리 형태의 변화가 의심되는 상태입니다.",

    "D_A1": "피부에 작은 돌기나 넓게 올라온 병변이 의심되는 상태입니다.",
    "D_A2": "피부 표면에 비듬, 각질, 원형 잔고리 형태의 변화가 의심되는 상태입니다.",
    "D_A3": "피부가 두꺼워지거나 색이 짙어지는 변화가 의심되는 상태입니다.",
    "D_A4": "피부에 농포 또는 여드름과 유사한 변화가 의심되는 상태입니다.",
    "D_A5": "피부 표면이 벗겨지거나 궤양처럼 손상된 변화가 의심되는 상태입니다.",
    "D_A6": "피부에 결절이나 종괴처럼 만져지는 덩어리 형태의 변화가 의심되는 상태입니다.",
}


DOG_CODES = ["D_A1", "D_A2", "D_A3", "D_A4", "D_A5", "D_A6"]
CAT_CODES = ["C_A2", "C_A4", "C_A6"]


def normalize_species(species: str) -> Tuple[str, List[str]]:
    value = species.strip().lower()

    if value in ["dog", "dogs", "강아지", "반려견", "개"]:
        return "dog", DOG_CODES

    if value in ["cat", "cats", "고양이", "반려묘", "냥이"]:
        return "cat", CAT_CODES

    raise HTTPException(
        status_code=400,
        detail="species는 dog 또는 cat이어야 합니다.",
    )


def safe_torch_load(path: Path):
    try:
        return torch.load(path, map_location=device, weights_only=False)
    except TypeError:
        return torch.load(path, map_location=device)


def load_ai_model():
    if not MODEL_PATH.exists():
        raise RuntimeError(f"모델 파일을 찾을 수 없습니다: {MODEL_PATH}")

    checkpoint = safe_torch_load(MODEL_PATH)

    if "class_names" not in checkpoint:
        raise RuntimeError("체크포인트에 class_names가 없습니다.")

    if "model_state_dict" not in checkpoint:
        raise RuntimeError("체크포인트에 model_state_dict가 없습니다.")

    loaded_class_names = checkpoint["class_names"]

    loaded_model = convnext_tiny(weights=None)

    num_classes = len(loaded_class_names)
    in_features = loaded_model.classifier[2].in_features
    loaded_model.classifier[2] = nn.Linear(in_features, num_classes)

    state_dict = checkpoint["model_state_dict"]

    new_state_dict = {}
    for key, value in state_dict.items():
        new_key = key.replace("module.", "")
        new_state_dict[new_key] = value

    loaded_model.load_state_dict(new_state_dict)
    loaded_model.to(device)
    loaded_model.eval()

    return loaded_model, loaded_class_names


model, class_names = load_ai_model()

image_transform = transforms.Compose(
    [
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(
            mean=[0.485, 0.456, 0.406],
            std=[0.229, 0.224, 0.225],
        ),
    ]
)


def confidence_level(confidence_percent: float) -> str:
    if confidence_percent >= 80:
        return "높음"
    if confidence_percent >= 60:
        return "보통"
    return "낮음"


def confidence_message(confidence_percent: float) -> str:
    if confidence_percent >= 80:
        return "AI가 비교적 높은 확률로 해당 피부 상태를 예측했습니다."
    if confidence_percent >= 60:
        return "AI가 해당 피부 상태를 예측했지만, 사진 상태나 촬영 환경에 따라 결과가 달라질 수 있습니다."
    return "예측 신뢰도가 낮습니다. 더 선명한 사진으로 다시 분석하거나 동물병원 상담을 권장합니다."


def make_result_item(code: str, probability: float) -> Dict[str, Any]:
    confidence_percent = round(float(probability) * 100, 2)
    display_name = label_display_names.get(code, code)

    return {
        "label": code,
        "label_code": code,
        "displayName": display_name,
        "label_name": display_name,
        "description": label_descriptions.get(
            code,
            "피부 상태 확인이 필요한 것으로 예측되었습니다.",
        ),
        "confidence": round(float(probability), 4),
        "confidencePercent": confidence_percent,
        "confidenceLevel": confidence_level(confidence_percent),
    }


@app.get("/")
def home():
    return {
        "success": True,
        "message": "Pet Skin AI Server is running",
        "device": str(device),
        "model_loaded": True,
        "model_path": str(MODEL_PATH),
        "classes": class_names,
        "label_display_names": label_display_names,
        "species_filter": {
            "dog": DOG_CODES,
            "cat": CAT_CODES,
        },
        "endpoints": {
            "predict": "/predict",
            "send_verification_code": "/send-verification-code",
            "verify_code": "/verify-code",
            "verification_status": "/verification-status",
            "docs": "/docs",
        },
    }


@app.get("/health")
def health_check():
    return {
        "success": True,
        "status": "ok",
        "device": str(device),
        "model_loaded": True,
    }


@app.post("/predict")
async def predict(
    file: UploadFile = File(...),
    species: str = Form("dog"),
):
    if file is None:
        raise HTTPException(
            status_code=400,
            detail="이미지 파일이 필요합니다.",
        )

    selected_species, allowed_codes = normalize_species(species)

    print(
        f"[PREDICT] filename={file.filename}, "
        f"content_type={file.content_type}, species={selected_species}"
    )

    try:
        image_bytes = await file.read()

        if not image_bytes:
            raise HTTPException(
                status_code=400,
                detail="빈 이미지 파일입니다.",
            )

        image = Image.open(BytesIO(image_bytes)).convert("RGB")

    except UnidentifiedImageError:
        raise HTTPException(
            status_code=400,
            detail="이미지를 읽을 수 없습니다. JPG 또는 PNG 파일을 사용해주세요.",
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"이미지 처리 중 오류가 발생했습니다: {str(e)}",
        )

    input_tensor = image_transform(image).unsqueeze(0).to(device)

    try:
        with torch.no_grad():
            outputs = model(input_tensor)
            full_probabilities = torch.softmax(outputs, dim=1)[0]

        allowed_indices = [
            i for i, code in enumerate(class_names)
            if code in allowed_codes
        ]

        if not allowed_indices:
            raise HTTPException(
                status_code=500,
                detail="해당 동물 종류에 맞는 클래스가 모델에 없습니다.",
            )

        allowed_probabilities = full_probabilities[allowed_indices]
        allowed_sum = torch.sum(allowed_probabilities)

        if float(allowed_sum.item()) <= 0:
            species_probabilities = allowed_probabilities
        else:
            species_probabilities = allowed_probabilities / allowed_sum

        confidence, local_predicted_idx = torch.max(
            species_probabilities,
            dim=0,
        )

        predicted_idx = allowed_indices[local_predicted_idx.item()]
        predicted_code = class_names[predicted_idx]
        confidence_percent = round(float(confidence.item()) * 100, 2)

        top_values, top_local_indices = torch.topk(
            species_probabilities,
            k=min(3, len(allowed_indices)),
        )

        top3 = []
        for value, local_index in zip(top_values, top_local_indices):
            global_index = allowed_indices[local_index.item()]
            code = class_names[global_index]
            top3.append(make_result_item(code, float(value.item())))

        probabilities_by_code = {}
        probabilities_by_name = {}

        for local_index, global_index in enumerate(allowed_indices):
            code = class_names[global_index]
            percent = round(float(species_probabilities[local_index].item()) * 100, 2)
            probabilities_by_code[code] = percent
            probabilities_by_name[label_display_names.get(code, code)] = percent

        raw_probabilities_by_code = {
            class_names[i]: round(float(full_probabilities[i].item()) * 100, 2)
            for i in range(len(class_names))
        }

        main_result = make_result_item(
            predicted_code,
            float(confidence.item()),
        )

        return {
            "success": True,

            "species": selected_species,
            "allowedLabels": allowed_codes,

            "label": predicted_code,
            "label_code": predicted_code,
            "displayName": main_result["displayName"],
            "label_name": main_result["label_name"],
            "description": main_result["description"],
            "confidence": main_result["confidence"],
            "confidencePercent": confidence_percent,
            "confidenceLevel": main_result["confidenceLevel"],
            "confidenceMessage": confidence_message(confidence_percent),
            "top3": top3,

            "probabilities": probabilities_by_code,
            "probabilitiesByName": probabilities_by_name,
            "rawProbabilities": raw_probabilities_by_code,

            "notice": "AI 분석 결과는 참고용이며, 정확한 진단은 동물병원 진료를 통해 확인해주세요.",
            "recommendation": "피부 변화가 지속되거나 악화되면 가까운 동물병원 상담을 권장합니다.",
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"AI 예측 중 오류가 발생했습니다: {str(e)}",
        )
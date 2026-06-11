# AI 기반 반려동물 피부질환 분류 및 위치 기반 동물병원 매칭 시스템

## 팀명

장송이

## 팀원

* 이민아
* 송은주
* 장승기

---

## 1. 프로젝트 개요

본 프로젝트는 반려견과 반려묘의 피부질환 이미지를 기반으로 의심 질환 클래스를 분류하고, 사용자의 위치를 기준으로 주변 동물병원 정보를 제공하는 모바일 앱 시스템이다.

반려동물은 스스로 증상을 말할 수 없기 때문에 보호자가 피부 이상을 초기에 정확히 인지하기 어렵다. 이로 인해 피부질환이 악화된 후 뒤늦게 동물병원을 방문하는 경우가 발생할 수 있으며, 반려동물의 고통과 보호자의 진료비 부담이 함께 증가할 수 있다.

이에 본 프로젝트에서는 AI 기반 피부질환 이미지 분류 모델을 활용하여 반려동물 피부 사진의 의심 질환을 분류하고, 위치 기반 동물병원 안내 기능을 함께 제공하여 보호자가 빠르게 대응할 수 있도록 돕는 것을 목표로 한다.

본 시스템은 수의사의 전문적인 진단을 대체하기 위한 목적이 아니라, 반려동물 피부 이상을 조기에 인지하고 병원 상담을 고려할 수 있도록 돕는 보조 도구이다.

---

## 2. 주요 기능

* 반려동물 피부 사진 촬영 및 업로드
* AI 모델 기반 피부질환 의심 클래스 분류
* 질환명 및 신뢰도 표시
* 분석 결과 저장
* 캘린더 기반 피부 분석 기록 관리
* 반려동물 정보 등록 및 관리
* Firebase 기반 회원가입 및 로그인
* 로그인 상태 유지 및 마이페이지 기능
* Kakao Local API 기반 주변 동물병원 검색
* 피부질환 관련 안내 문구 제공

---

## 3. 시스템 구성

본 프로젝트는 Flutter 모바일 앱, FastAPI 서버, PyTorch 기반 AI 모델, Firebase, Kakao Local API로 구성된다.

```text
사용자
  ↓
Flutter 모바일 앱
  ↓
피부 사진 촬영 또는 업로드
  ↓
FastAPI 서버로 이미지 전송
  ↓
PyTorch 기반 피부질환 분류 모델 분석
  ↓
질환 클래스 및 신뢰도 반환
  ↓
앱 결과 화면 표시
  ↓
분석 기록 저장 및 주변 동물병원 검색
```

---

## 4. 프로젝트 폴더 구조

```text
mungnyang-care/
│
├── app/
│   ├── lib/
│   ├── assets/
│   ├── android/
│   ├── pubspec.yaml
│   └── pubspec.lock
│
├── server/
│   ├── main.py
│   ├── requirements.txt
│   ├── .env.example
│   └── models/
│       └── .gitkeep
│
├── docs/
│   ├── flowchart.png
│   ├── app_home.png
│   ├── app_analysis.png
│   └── app_result.png
│
├── sample_data/
│   └── sample_skin_image.jpg
│
├── README.md
└── .gitignore
```

---

## 5. 사용 데이터셋

### 데이터 출처

* 데이터명: AI Hub 반려동물 피부질환 데이터
* 데이터셋 번호: 561
* 제공기관: AI Hub
* 데이터 유형: 반려견 및 반려묘 피부질환 이미지

AI Hub 반려동물 피부질환 데이터는 반려견과 반려묘의 피부질환 이미지 및 부위별 라벨링 정보를 포함한다. 본 프로젝트에서는 전체 데이터셋 중 반려견과 반려묘 피부질환 이미지 데이터를 활용하였다.

데이터셋은 용량 및 라이선스 문제로 GitHub 저장소에 포함하지 않는다. 재현을 원하는 경우 AI Hub에서 동일 데이터셋을 다운로드한 뒤, 본 프로젝트에서 사용한 폴더 구조에 맞게 배치해야 한다.

---

## 6. 데이터 정제 및 구성

원본 데이터에는 반려견과 반려묘의 다양한 피부질환 이미지, 무증상 이미지, 감염성 피부 이미지 등이 포함되어 있다. 본 프로젝트에서는 모델 학습에 적합한 데이터셋을 구성하기 위해 다음과 같은 정제 과정을 수행하였다.

* 무증상 데이터 제외
* 데이터 수가 부족하거나 특징 추출이 어려운 클래스 제외
* 현미경 기반 감염성 피부 이미지 제외
* 이미지 파일과 JSON 라벨 파일 매칭
* JSON 파일이 존재하지 않는 이미지 데이터 제거
* 병변 위치 정보를 활용한 Crop 데이터셋 구성
* 클래스 간 데이터 수 균형 조정

추가 데이터 정제 과정에서 전체 데이터는 약 18,693장까지 확보하였으나, 최종 모델 학습 및 성능 평가에는 전처리와 폴더 구조 정리가 완료된 17,988장의 이미지를 사용하였다.

---

## 7. 클래스 구성

최종 모델은 총 9개 클래스를 분류한다.

### 반려묘 클래스

| 클래스  | 질환명              |
| ---- | ---------------- |
| C_A2 | 비듬 / 각질 / 상피성잔고리 |
| C_A4 | 농포 / 여드름         |
| C_A6 | 결절 / 종괴          |

### 반려견 클래스

| 클래스  | 질환명              |
| ---- | ---------------- |
| D_A1 | 구진 / 플라크         |
| D_A2 | 비듬 / 각질 / 상피성잔고리 |
| D_A3 | 태선화 / 과다색소침착     |
| D_A4 | 농포 / 여드름         |
| D_A5 | 미란 / 궤양          |
| D_A6 | 결절 / 종괴          |

---

## 8. 데이터셋 구성

### 최종 학습 및 평가 데이터셋 요약

| 구분 | 수량 |
|---|---:|
| 반려견 6개 클래스 | 12,056장 |
| 반려묘 3개 클래스 | 5,932장 |
| 전체 | 17,988장 |

### 최종 학습 및 평가 데이터셋

| Class | Train | Validation | Test |
|---|---:|---:|---:|
| C_A2 | 1,776 | 221 | 224 |
| C_A4 | 1,440 | 175 | 170 |
| C_A6 | 1,535 | 193 | 198 |
| D_A1 | 799 | 99 | 102 |
| D_A2 | 1,766 | 218 | 225 |
| D_A3 | 1,774 | 219 | 227 |
| D_A4 | 1,769 | 218 | 223 |
| D_A5 | 1,764 | 216 | 223 |
| D_A6 | 1,770 | 218 | 226 |

| Split | Images |
|---|---:|
| Train | 14,393 |
| Validation | 1,777 |
| Test | 1,818 |
| Total | 17,988 |

---

## 9. 데이터 전처리

원본 이미지를 학습에 적합한 형태로 변환하기 위해 별도의 전처리 코드를 사용하였다.

### 전처리 입력 및 출력 경로 예시

```python
INPUT_DIR = "dataset/cropped_dataset_more"
OUTPUT_DIR = "dataset/cropped_preprocessed_dataset"
```

### 적용한 전처리 과정

1. Resize

   * 모든 이미지를 320 × 320 크기로 변환

2. Gaussian Blur

   * 커널 크기 3 × 3 적용

3. CLAHE

   * LAB 색공간으로 변환한 뒤 L 채널에 CLAHE 적용
   * clipLimit = 2.0
   * tileGridSize = (8, 8)

4. Gamma Correction

   * gamma = 1.1 적용

5. 폴더 구조 유지 저장

   * 입력 데이터셋의 train / validation / test 및 클래스 폴더 구조를 유지한 상태로 저장

### 전처리 흐름

```text
cropped_dataset_more
        ↓
이미지 파일 탐색
        ↓
Resize (320 × 320)
        ↓
Gaussian Blur (3 × 3)
        ↓
CLAHE
        ↓
Gamma Correction (γ = 1.1)
        ↓
cropped_preprocessed_dataset 저장
```

---

## 10. 데이터 증강

학습 코드에서는 학습 데이터에 대해서만 다음 증강을 적용하였다.

| Augmentation           | 설정                  |
| ---------------------- | ------------------- |
| Resize                 | 320 × 320           |
| Random Horizontal Flip | p = 0.5             |
| Random Rotation        | 10도                 |
| Color Jitter           | brightness = 0.15   |
| Color Jitter           | contrast = 0.15     |
| Color Jitter           | saturation = 0.15   |
| Normalize              | ImageNet mean / std |

Validation 및 Test 데이터에는 Resize, Tensor 변환, Normalize만 적용하였다.

---

## 11. 실험 환경

| 항목          | 내용                            |
| ----------- | ----------------------------- |
| OS          | Windows 11 Home 24H2          |
| CPU         | Intel Core i7-10700 @ 2.90GHz |
| RAM         | 16GB                          |
| GPU         | NVIDIA GeForce RTX 5060 8GB   |
| Python      | 3.10                          |
| CUDA        | 12.8                          |
| PyTorch     | 2.11.0+cu128                  |
| Framework   | PyTorch                       |
| IDE         | Visual Studio Code / Anaconda |
| Random Seed | 42                            |

---

## 12. 사용 모델

실험 과정에서 다음 모델들을 비교하거나 검토하였다.

* ResNet50
* DenseNet169
* EfficientNet-B2
* EfficientNet-B7
* MobileNetV2
* ConvNeXt-Tiny
* ConvNeXt-Small
* ConvNeXt-Base

중간 실험에서는 EfficientNet-B2가 안정적인 성능을 보였으며, 이후 ConvNeXt 계열 모델을 추가로 적용하여 성능 비교를 수행하였다. 최종 앱 연동 모델은 테스트 성능과 구현 안정성을 고려하여 ConvNeXt-Tiny 기반 모델을 사용하였다.

---

## 13. 모델 학습 설정

본 프로젝트에서는 ImageNet으로 사전학습된 ConvNeXt-Tiny 모델을 사용하였다. 기존 ConvNeXt-Tiny의 마지막 classifier layer를 9개 클래스에 맞게 수정한 뒤 fine-tuning을 수행하였다.

| 항목                 | 설정                  |
| ------------------ | ------------------- |
| Model              | ConvNeXt-Tiny       |
| Pretrained Weight  | ImageNet pretrained |
| Number of Classes  | 9                   |
| Input Size         | 320 × 320           |
| Batch Size         | 8                   |
| Epoch              | 25                  |
| Learning Rate      | 1e-4                |
| Optimizer          | AdamW               |
| Loss Function      | CrossEntropyLoss    |
| Scheduler          | ReduceLROnPlateau   |
| Scheduler Mode     | min                 |
| Scheduler Factor   | 0.5                 |
| Scheduler Patience | 2                   |
| Num Workers        | 0                   |
| Device             | CUDA 사용 가능 시 GPU 사용 |

---

## 14. 모델 학습 흐름

```text
AI Hub 데이터 다운로드
        ↓
클래스별 데이터 정리
        ↓
이미지와 JSON 라벨 파일 매칭
        ↓
병변 위치 정보를 활용한 Crop 데이터셋 구성
        ↓
전처리 수행
Resize → Gaussian Blur → CLAHE → Gamma Correction
        ↓
Train / Validation / Test 데이터 구성
        ↓
ImageFolder를 이용한 데이터 로드
        ↓
Train 데이터 증강 적용
        ↓
ConvNeXt-Tiny 모델 불러오기
        ↓
Classifier를 9개 클래스에 맞게 수정
        ↓
AdamW + CrossEntropyLoss로 학습
        ↓
Validation Accuracy 기준 Best Model 선정
        ↓
Best Model로 Test Dataset 평가
        ↓
Classification Report 및 Confusion Matrix 저장
```

---

## 15. 모델 학습 결과

### Best Epoch Model

```text
new_conv/epoch_models/epoch_22_trainLoss_0.0058_trainAcc_0.9990_valLoss_1.6490_valAcc_0.7113.pth
```

### 전체 성능

| Metric                   |  Score |
| ------------------------ | -----: |
| Best Validation Accuracy | 71.13% |
| Test Loss                | 1.4354 |
| Test Accuracy            | 74.26% |
| Macro Precision          | 73.46% |
| Macro Recall             | 73.37% |
| Macro F1-Score           | 73.34% |
| Weighted Precision       | 73.86% |
| Weighted Recall          | 74.26% |
| Weighted F1-Score        | 73.99% |

### 클래스별 성능

| Class | Precision | Recall | F1-Score | Support |
| ----- | --------: | -----: | -------: | ------: |
| C_A2  |    87.83% | 90.18% |   88.99% |     224 |
| C_A4  |    82.32% | 79.41% |   80.84% |     170 |
| C_A6  |    90.00% | 95.45% |   92.65% |     198 |
| D_A1  |    60.00% | 52.94% |   56.25% |     102 |
| D_A2  |    66.39% | 70.22% |   68.25% |     225 |
| D_A3  |    64.65% | 61.23% |   62.90% |     227 |
| D_A4  |    59.20% | 53.36% |   56.13% |     223 |
| D_A5  |    66.10% | 69.96% |   67.97% |     223 |
| D_A6  |    84.62% | 87.61% |   86.09% |     226 |

---

## 16. 결과 분석

전체 Test Accuracy는 74.26%로 나타났다.

반려묘 클래스인 C_A2, C_A4, C_A6는 상대적으로 높은 성능을 보였으며, 특히 C_A6 클래스는 F1-Score 92.65%로 가장 높은 성능을 기록하였다.

반려견 클래스 중에서는 D_A6이 F1-Score 86.09%로 가장 높은 성능을 보였다.

반면 D_A1과 D_A4 클래스는 상대적으로 낮은 성능을 보였다. D_A1은 다른 클래스에 비해 데이터 수가 적고, D_A4는 D_A2, D_A3, D_A5 등 다른 반려견 질환 클래스와 혼동되는 경우가 많았다.

Confusion Matrix 분석 결과, 반려묘 클래스보다 반려견 클래스 간의 오분류가 더 많이 발생하였다. 이는 반려견 피부질환 클래스들이 시각적으로 유사한 병변 형태를 공유하기 때문으로 판단된다.

---

## 17. 앱 개발 환경

| 항목                 | 내용                                  |
| ------------------ | ----------------------------------- |
| Framework          | Flutter                             |
| Language           | Dart                                |
| IDE                | Visual Studio Code / Android Studio |
| Test Device        | Android Emulator                    |
| Backend            | FastAPI                             |
| Authentication     | Firebase                            |
| Map / Local Search | Kakao Local API                     |

우선 Android 환경에서 실행 가능한 앱을 중심으로 개발하였다. Android Studio에서 Android SDK와 에뮬레이터 환경을 구성하고, VS Code에서 Flutter 프로젝트를 실행하며 화면 이동, 이미지 표시, 서버 연결, 지도 연동 기능을 점검하였다.

---

## 18. 앱 주요 화면 및 기능

### 카테고리 화면

앱의 주요 기능을 한곳에서 확인하고 이동할 수 있도록 구성한 화면이다. 피부 기록 관리 영역에는 AI 피부 캘린더와 피부 변화 그래프를 배치하여 분석 날짜와 피부 상태 변화 흐름을 확인할 수 있도록 하였다.

### AI 피부 캘린더 화면

반려동물의 피부 분석 기록을 날짜별로 관리하기 위한 화면이다. 사용자는 월별 캘린더에서 원하는 날짜를 선택할 수 있으며, 선택한 날짜에 저장된 피부 분석 기록을 확인할 수 있다.

### 마이페이지 화면

사용자 계정 정보와 앱 설정을 관리하기 위한 화면이다. 로그인 상태에서는 사용자 이름, 이메일, 인증 상태, 가입일을 확인할 수 있으며, 로그아웃 시 인증 상태가 해제되고 화면 상태가 변경되도록 구현하였다.

### 반려동물 등록 화면

여러 마리의 반려동물 정보를 등록하고 관리할 수 있도록 구성한 화면이다. 사진, 이름, 품종, 나이, 몸무게, 성별, 피부 특이사항, 메모 등을 입력할 수 있다.

### 병원 찾기 화면

Kakao Local API를 활용하여 사용자의 위치 또는 검색어를 기준으로 주변 동물병원을 확인할 수 있도록 구성하였다.

---

## 19. FastAPI 서버 실행 방법

서버 코드는 `server/` 폴더에 위치한다.

```bash
cd server
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

서버 실행 후 기본 접속 주소는 다음과 같다.

```text
http://localhost:8000
```

Android Emulator에서 Flutter 앱이 로컬 서버에 접속할 경우 다음 주소를 사용한다.

```text
http://10.0.2.2:8000
```

---

## 20. Flutter 앱 실행 방법

Flutter 앱 코드는 `app/` 폴더에 위치한다.

```bash
cd app
flutter pub get
flutter run
```

앱 실행 전 Android Emulator 또는 실제 Android 기기를 연결해야 한다.

---

## 21. 환경 설정 파일

보안상 실제 API 키와 Firebase 설정 파일은 저장소에 포함하지 않는다. 실행 전 example 파일을 참고하여 실제 설정 파일을 생성해야 한다.

### Kakao API 설정

예시 파일:

```text
app/lib/config/kakao_keys.example.dart
```

실제 실행용 파일:

```text
app/lib/config/kakao_keys.dart
```

예시:

```dart
class KakaoKeys {
  static const String restApiKey = 'YOUR_KAKAO_REST_API_KEY';
  static const String javascriptKey = 'YOUR_KAKAO_JAVASCRIPT_KEY';
}
```

### Firebase 설정

예시 파일:

```text
app/lib/firebase_options.example.dart
app/android/app/google-services.example.json
```

실제 실행용 파일:

```text
app/lib/firebase_options.dart
app/android/app/google-services.json
```

Firebase 설정 파일은 FlutterFire CLI를 이용해 생성하거나, 본인의 Firebase 프로젝트 설정값을 이용해 직접 작성해야 한다.

### Server 환경 변수

예시 파일:

```text
server/.env.example
```

실제 실행용 파일:

```text
server/.env
```

예시:

```env
EMAIL_USER=YOUR_EMAIL
EMAIL_PASSWORD=YOUR_EMAIL_PASSWORD
SMTP_SERVER=smtp.naver.com
SMTP_PORT=587
```

---

## 22. 모델 파일 사용 방법

모델 파일은 용량 문제로 GitHub 저장소에 직접 포함하지 않는다. 모델 파일은 외부 저장소 링크를 통해 제공하며, 다운로드 후 아래 경로에 저장해야 한다.

```text
server/models/pet_skin_model.pth
```

모델 다운로드 링크:

```text
Google Drive 또는 OneDrive 링크 입력
```

---

## 23. requirements.txt

서버 실행 및 모델 추론에 필요한 Python 패키지는 `server/requirements.txt`에 정리한다.

```txt
fastapi
uvicorn
python-multipart
pillow
torch
torchvision
numpy
python-dotenv
opencv-python
matplotlib
scikit-learn
tqdm
```

CUDA 12.8 환경에서 PyTorch를 설치하는 경우 다음 명령어를 사용할 수 있다.

```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
```

---

## 24. 모델 학습 코드 실행 방법

학습 코드는 별도 학습 폴더 또는 서버 폴더 내 학습 코드에 따라 실행할 수 있다.

### 1) 가상환경 생성

```bash
conda create -n pet_skin python=3.10
conda activate pet_skin
```

### 2) 라이브러리 설치

```bash
pip install -r requirements.txt
```

### 3) 이미지 전처리

```bash
python preprocess.py
```

### 4) 모델 학습

```bash
python train.py
```

### 5) 모델 평가

```bash
python test.py
```

### 6) 단일 이미지 예측

```bash
python predict.py
```

---

## 25. 샘플 이미지 및 화면 자료

테스트용 샘플 이미지는 `sample_data/` 폴더에 1~2장 포함할 수 있다.

앱 화면 캡처와 시스템 흐름도는 `docs/` 폴더에 저장한다.

```text
docs/
├── flowchart.png
├── app_home.png
├── app_analysis.png
└── app_result.png
```

---

## 26. 재현 시 주의사항

1. 데이터셋은 AI Hub에서 직접 다운로드해야 한다.
2. 입력 데이터는 train / validation / test 폴더 구조를 유지해야 한다.
3. 각 클래스 폴더명은 C_A2, C_A4, C_A6, D_A1, D_A2, D_A3, D_A4, D_A5, D_A6 형식을 따라야 한다.
4. 전처리 후 데이터는 `dataset/cropped_preprocessed_dataset` 폴더에 저장된다.
5. PyTorch, CUDA, torchvision 버전에 따라 실행 결과가 달라질 수 있다.
6. 모델 파일 `.pth`는 용량 문제로 GitHub에 직접 업로드하지 않고 별도 링크로 제공한다.
7. Random Seed를 고정하였지만, GPU 연산 환경에 따라 완전히 동일한 결과가 나오지 않을 수 있다.
8. Firebase, Kakao API, 이메일 인증 관련 설정 파일은 보안상 저장소에 포함하지 않는다.

---

## 27. GitHub 업로드 제외 항목

```gitignore
cropped_dataset_more/
cropped_preprocessed_dataset/
dataset/
*.pth
*.pt
*.onnx
.env
__pycache__/
.ipynb_checkpoints/
build/
.dart_tool/
app/lib/firebase_options.dart
app/android/app/google-services.json
app/lib/config/kakao_keys.dart
app/lib/secrets/kakao_keys.dart
```

모델 재현을 위해 필요한 `.pth` 파일은 Google Drive, OneDrive, Hugging Face Hub 등 외부 저장소에 업로드한 후 README에 링크를 첨부한다.

---

## 28. 참고 자료

* AI Hub. 반려동물 피부질환 데이터. 데이터셋 번호 561.
* PyTorch Documentation
* TorchVision Documentation
* Scikit-Learn Documentation
* OpenCV Documentation
* Flutter Documentation
* Firebase Documentation
* Kakao Developers Documentation

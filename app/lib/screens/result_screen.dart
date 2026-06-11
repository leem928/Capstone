import 'package:flutter/material.dart';
import '../widgets/menu_button.dart';
import '../theme/app_colors.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Widget _resultHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.soft,
            child: const Icon(
              Icons.health_and_safety_outlined,
              size: 34,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'AI 분석 결과',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '사진 기반으로 반려견 피부 상태를 분석한 결과입니다.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String content,
    IconData? icon,
    Color iconColor = AppColors.primary,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            CircleAvatar(
              radius: 22,
              backgroundColor: iconColor.withOpacity(0.12),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _confidenceCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EEE8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3CDBD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '신뢰도 / 확률',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: const LinearProgressIndicator(
              value: 0.87,
              minHeight: 14,
              backgroundColor: Color(0xFFEADDD4),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '87%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _warningBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0D3C8)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFC47A5A)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '본 결과는 참고용 분석이며, 정확한 진단은 수의사의 진료를 통해 확인해야 합니다.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF4E9E1),
            Color(0xFFFFFBF8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '분석 결과 요약',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'AI가 촬영된 피부 부위를 분석해 주요 이상 소견을 정리했어요.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 결과'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _topBanner(),
              const SizedBox(height: 18),
              _resultHeaderCard(),
              const SizedBox(height: 20),
              _infoCard(
                title: '의심 질환명',
                content: '피부염 의심',
                icon: Icons.medical_information_outlined,
                iconColor: AppColors.primaryDark,
              ),
              _confidenceCard(),
              _infoCard(
                title: '증상 설명',
                content: '촬영된 피부 부위에서 붉은 발진과 각질, 자극으로 보이는 이상 소견이 관찰됩니다.',
                icon: Icons.description_outlined,
                iconColor: AppColors.primary,
              ),
              _infoCard(
                title: '주의사항',
                content: '해당 부위를 계속 긁거나 핥는 행동이 지속될 경우 피부 손상이 악화될 수 있습니다.',
                icon: Icons.error_outline,
                iconColor: const Color(0xFFC47A5A),
              ),
              _infoCard(
                title: '집에서 할 수 있는 기본 관리',
                content: '병변 부위를 청결하게 유지하고, 자극이 심한 제품 사용은 피해주세요.',
                icon: Icons.home_outlined,
                iconColor: AppColors.primary,
              ),
              _infoCard(
                title: '병원 방문 권장 여부',
                content: '빠른 시일 내 동물병원 상담을 권장합니다.',
                icon: Icons.local_hospital_outlined,
                iconColor: AppColors.primaryDark,
              ),
              const SizedBox(height: 6),
              _warningBox(),
              const SizedBox(height: 24),
              MenuButton(
                title: '주변 병원 보기',
                icon: Icons.local_hospital,
                onTap: () {
                  Navigator.pushNamed(context, '/hospital-map');
                },
              ),
              const SizedBox(height: 12),
              MenuButton(
                title: '홈으로 돌아가기',
                icon: Icons.home_outlined,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
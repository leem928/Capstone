import 'package:flutter/material.dart';
import '../widgets/menu_button.dart';
import '../theme/app_colors.dart';

class CaptureGuideScreen extends StatelessWidget {
  const CaptureGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> guides = [
      '털을 최대한 젖히고 병변 부위가 잘 보이게 촬영해주세요.',
      '밝은 곳에서 촬영해주세요.',
      '흔들리지 않게 촬영해주세요.',
      '병변 부위를 조금 더 가까이 확대해서 촬영해주세요.',
      '가능하면 여러 각도에서 촬영해주세요.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('촬영 가이드'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '정확한 AI 분석을 위해\n촬영 가이드를 확인해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '사진 품질이 좋을수록 분석 정확도가 높아집니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '촬영 전 확인사항',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...guides.map(
              (guide) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        guide,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            MenuButton(
              title: '분석 시작',
              icon: Icons.arrow_forward,
              onTap: () {
                Navigator.pushNamed(context, '/analysis-loading');
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/menu_button.dart';
import '../theme/app_colors.dart';

class AnalysisLoadingScreen extends StatelessWidget {
  const AnalysisLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> steps = [
      '이미지 업로드 중',
      'AI 분석 중',
      '결과 생성 중',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 분석 중'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: AppColors.soft,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                '피부 상태를 분석하고 있어요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '잠시만 기다려주세요.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),
              ...steps.map(
                (step) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MenuButton(
                title: '결과 화면으로 이동',
                icon: Icons.arrow_forward,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/result');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
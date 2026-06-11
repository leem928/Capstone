import 'package:flutter/material.dart';
import '../widgets/menu_button.dart';
import '../theme/app_colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  Widget _inputField({
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '회원가입 후 반려견 정보를 등록하고 피부 분석 기록을 저장할 수 있습니다.',
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
            '회원가입',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '간단한 정보 입력 후 서비스를 시작해보세요.',
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
        title: const Text('회원가입'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _topBanner(),
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.soft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_add_alt_1,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '새 계정 만들기',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '간단한 정보 입력 후 서비스를 시작해보세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              _inputField(
                label: '이메일',
                hint: 'example@email.com',
                icon: Icons.email_outlined,
              ),
              _inputField(
                label: '비밀번호',
                hint: '비밀번호를 입력하세요',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              _inputField(
                label: '비밀번호 확인',
                hint: '비밀번호를 다시 입력하세요',
                icon: Icons.lock_reset_outlined,
                obscureText: true,
              ),
              const SizedBox(height: 8),
              _infoBox(),
              const SizedBox(height: 24),
              MenuButton(
                title: '가입 완료',
                icon: Icons.check_circle_outline,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('이미 계정이 있나요? 로그인으로 돌아가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
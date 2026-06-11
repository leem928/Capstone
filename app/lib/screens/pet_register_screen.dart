import 'package:flutter/material.dart';
import '../widgets/menu_button.dart';
import '../theme/app_colors.dart';

class PetRegisterScreen extends StatelessWidget {
  const PetRegisterScreen({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    String? hint,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
      ),
    );
  }

  Widget _photoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            radius: 42,
            backgroundColor: AppColors.soft,
            child: const Icon(
              Icons.pets,
              size: 42,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '반려견 사진 등록',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '프로필용 사진 또는 대표 사진을 등록해주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('사진 선택'),
          ),
        ],
      ),
    );
  }

  Widget _diseaseCheckBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '기존 피부질환 여부',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                '있음',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              SizedBox(width: 24),
              Icon(Icons.radio_button_unchecked, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text(
                '없음',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ],
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
            '반려견 등록',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '반려견 정보를 등록하고 피부 분석 기록을 더 편리하게 관리해보세요.',
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
        title: const Text('반려견 등록'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBanner(),
              const SizedBox(height: 18),
              _photoBox(),
              const SizedBox(height: 28),
              _sectionTitle('기본 정보'),
              _inputField(
                label: '이름',
                hint: '반려견 이름을 입력하세요',
                icon: Icons.badge_outlined,
              ),
              _inputField(
                label: '품종',
                hint: '예: 말티즈, 푸들',
                icon: Icons.pets_outlined,
              ),
              _inputField(
                label: '나이',
                hint: '예: 3살',
                icon: Icons.cake_outlined,
              ),
              _inputField(
                label: '성별',
                hint: '예: 수컷 / 암컷',
                icon: Icons.wc_outlined,
              ),
              _inputField(
                label: '체중',
                hint: '예: 4.2kg',
                icon: Icons.monitor_weight_outlined,
              ),
              const SizedBox(height: 8),
              _sectionTitle('건강 정보'),
              _diseaseCheckBox(),
              const SizedBox(height: 28),
              MenuButton(
                title: '등록 완료',
                icon: Icons.check_circle_outline,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
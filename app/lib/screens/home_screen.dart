import 'package:flutter/material.dart';
import '../widgets/menu_button.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.soft,
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _recentRecordCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                '최근 분석 기록',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '2026-04-08',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '의심 질환: 피부염 의심',
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '신뢰도: 87%',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '상세 결과는 기록 화면에서 확인할 수 있습니다.',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _welcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            '반려견 피부 상태를\n간편하게 확인해보세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '사진 촬영, 분석 결과 확인, 주변 병원 찾기까지\n한 번에 연결할 수 있어요.',
            style: TextStyle(
              fontSize: 15,
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
        title: const Text('홈'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeBanner(),
            const SizedBox(height: 20),
            _infoCard(
              icon: Icons.pets,
              title: '반려견 피부 상태 분석',
              subtitle: '사진 촬영 또는 갤러리 이미지를 이용해 피부 상태를 분석해보세요.',
            ),
            const SizedBox(height: 24),
            _sectionTitle('빠른 메뉴'),
            const SizedBox(height: 14),
            MenuButton(
              title: '사진 촬영하기',
              icon: Icons.camera_alt_outlined,
              onTap: () {
                Navigator.pushNamed(context, '/capture-guide');
              },
            ),
            const SizedBox(height: 12),
            MenuButton(
              title: '갤러리에서 불러오기',
              icon: Icons.photo_library_outlined,
              onTap: () {
                Navigator.pushNamed(context, '/capture-guide');
              },
            ),
            const SizedBox(height: 12),
            MenuButton(
              title: '가까운 병원 찾기',
              icon: Icons.local_hospital_outlined,
              onTap: () {
                Navigator.pushNamed(context, '/hospital-map');
              },
            ),
            const SizedBox(height: 12),
            MenuButton(
              title: '마이페이지',
              icon: Icons.person_outline,
              onTap: () {
                Navigator.pushNamed(context, '/mypage');
              },
            ),
            const SizedBox(height: 28),
            _sectionTitle('최근 기록'),
            const SizedBox(height: 14),
            _recentRecordCard(),
            const SizedBox(height: 16),
            MenuButton(
              title: '전체 분석 기록 보기',
              icon: Icons.history,
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

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

  Widget _menuCard({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color iconColor = AppColors.primary,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: iconColor.withOpacity(0.12),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: AppColors.primaryDark,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.soft,
            child: Icon(
              Icons.person,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '사용자 이름',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'example@email.com',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '반려견 피부 상태 분석과 진료 연계를 도와드려요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
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
            '마이페이지',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '계정 정보와 반려견 프로필, 분석 기록을 한곳에서 관리할 수 있어요.',
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
        title: const Text('마이페이지'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topBanner(),
            const SizedBox(height: 18),
            _profileCard(),
            const SizedBox(height: 28),
            _sectionTitle('내 정보'),
            _menuCard(
              icon: Icons.person_outline,
              title: '내 정보 관리',
              subtitle: '이름, 이메일 등 기본 정보를 확인합니다.',
              onTap: () {},
            ),
            _menuCard(
              icon: Icons.pets,
              title: '반려견 프로필 관리',
              subtitle: '등록된 반려견 정보와 사진을 관리합니다.',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _sectionTitle('앱 설정'),
            _menuCard(
              icon: Icons.notifications_none,
              title: '알림 설정',
              subtitle: '분석 기록, 공지, 안내 알림을 설정합니다.',
              onTap: () {},
            ),
            _menuCard(
              icon: Icons.history,
              title: '분석 기록 보기',
              subtitle: '날짜별 피부 분석 결과를 다시 확인합니다.',
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
            const SizedBox(height: 16),
            _sectionTitle('기타'),
            _menuCard(
              icon: Icons.privacy_tip_outlined,
              title: '개인정보처리방침 / 약관',
              subtitle: '앱 이용 관련 정책을 확인합니다.',
              onTap: () {},
            ),
            _menuCard(
              icon: Icons.info_outline,
              title: '앱 정보',
              subtitle: '버전 정보 및 서비스 소개를 확인합니다.',
              onTap: () {},
            ),
            _menuCard(
              icon: Icons.logout,
              title: '로그아웃',
              subtitle: '현재 계정에서 로그아웃합니다.',
              iconColor: Colors.redAccent,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
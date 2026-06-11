import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _showPreparingMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title 기능은 준비 중입니다.'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _quickMenuCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 155,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.soft,
                child: Icon(
                  icon,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallInfoItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.soft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'AI 기반 반려동물 피부 케어',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Image.asset(
                      'assets/petscancare_logo.png',
                      width: 175,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      '멍냥케어',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      '사진 한 장으로 피부 상태를 확인하고\n가까운 동물병원까지 연결해보세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF7EDE7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.045),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.soft,
                          child: Icon(
                            Icons.auto_awesome,
                            color: AppColors.primary,
                            size: 25,
                          ),
                        ),

                        SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '오늘의 피부 체크',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              SizedBox(height: 4),

                              Text(
                                '피부 사진을 업로드하고 AI 분석을 시작해요.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Wrap(
                      spacing: 14,
                      runSpacing: 8,
                      children: [
                        _smallInfoItem(
                          icon: Icons.camera_alt_outlined,
                          text: '사진 분석',
                        ),
                        _smallInfoItem(
                          icon: Icons.local_hospital_outlined,
                          text: '병원 연결',
                        ),
                        _smallInfoItem(
                          icon: Icons.description_outlined,
                          text: '리포트 정리',
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/capture-guide');
                        },
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text(
                          '피부 분석 시작하기',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                '빠른 메뉴',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  _quickMenuCard(
                    icon: Icons.pets_outlined,
                    title: '반려동물 등록',
                    description: '기본 정보를 저장해요.',
                    onTap: () {
                      Navigator.pushNamed(context, '/pet-register');
                    },
                  ),

                  const SizedBox(width: 14),

                  _quickMenuCard(
                    icon: Icons.local_hospital_outlined,
                    title: '병원 찾기',
                    description: '가까운 병원을 확인해요.',
                    onTap: () {
                      Navigator.pushNamed(context, '/hospital-map');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  _quickMenuCard(
                    icon: Icons.bookmark_border_outlined,
                    title: '즐겨찾는 병원',
                    description: '자주 가는 병원을 저장해요.',
                    onTap: () {
                      _showPreparingMessage(context, '즐겨찾는 병원');
                      // 화면을 만들면 아래 코드로 변경
                      // Navigator.pushNamed(context, '/favorite-hospitals');
                    },
                  ),

                  const SizedBox(width: 14),

                  _quickMenuCard(
                    icon: Icons.history_outlined,
                    title: '분석 기록',
                    description: '이전 결과를 확인해요.',
                    onTap: () {
                      Navigator.pushNamed(context, '/history');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  _quickMenuCard(
                    icon: Icons.description_outlined,
                    title: '진료 리포트',
                    description: '진료용 결과를 정리해요.',
                    onTap: () {
                      _showPreparingMessage(context, '진료 리포트');
                      // 화면을 만들면 아래 코드로 변경
                      // Navigator.pushNamed(context, '/medical-report');
                    },
                  ),

                  const SizedBox(width: 14),

                  _quickMenuCard(
                    icon: Icons.person_outline,
                    title: '마이페이지',
                    description: '내 정보를 관리해요.',
                    onTap: () {
                      Navigator.pushNamed(context, '/mypage');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.border),
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    '로그인하고 기록 저장하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    '처음이신가요? 회원가입',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'AI 분석 결과는 참고용이며,\n정확한 진단은 동물병원 진료를 권장합니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
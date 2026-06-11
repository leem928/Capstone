import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> historyList = [
      {
        'date': '2026-04-08',
        'result': '피부염 의심',
        'confidence': '87%',
        'part': '복부 부위',
      },
      {
        'date': '2026-04-03',
        'result': '진균성 피부질환 의심',
        'confidence': '79%',
        'part': '귀 주변',
      },
      {
        'date': '2026-03-28',
        'result': '알레르기성 피부 이상 의심',
        'confidence': '82%',
        'part': '등 부위',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 기록'),
        centerTitle: true,
      ),
      body: historyList.isEmpty
          ? const Center(
              child: Text(
                '저장된 분석 기록이 없습니다.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
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
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.soft,
                      child: const Icon(
                        Icons.history,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      '${item['date']} 분석 결과',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '의심 질환: ${item['result']}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '신뢰도: ${item['confidence']}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '촬영 부위: ${item['part']}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: AppColors.primaryDark,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/result');
                    },
                  ),
                );
              },
            ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/sharing/provider/sharing_provider.dart';

class QTSharingListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QTSharingList = ref.watch(QTSharingProvider);

    String formatDate(String timestamp) {
      DateTime date = DateTime.parse(timestamp);
      return DateFormat('yyyy년 M월 d일').format(date);
    }

    return Scaffold(
      backgroundColor: AppColors.color1,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'QT 나눔 목록',
          style: AppTypography.headline3.copyWith(
            color: AppColors.color2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.color2),
      ),
      body: RefreshIndicator(
        color: AppColors.color4,
        onRefresh: () async {
          await ref.read(QTSharingProvider.notifier).refresh();
        },
        child: QTSharingList.when(
          data: (qtSharings) {
            // 날짜별 그룹핑
            Map<String, List<Map<String, dynamic>>> groupedData = {};
            for (var sharing in qtSharings) {
              String date = formatDate(sharing['createdAt']);
              groupedData.putIfAbsent(date, () => []).add(sharing);
            }

            // 날짜 최신순 정렬
            final sortedDates = groupedData.keys.toList()
              ..sort((a, b) => DateFormat('yyyy년 M월 d일')
                  .parse(b)
                  .compareTo(DateFormat('yyyy년 M월 d일').parse(a)));

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final dayItems = groupedData[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.color2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        date,
                        style: AppTypography.headline5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...dayItems.map((sharing) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.color6.withOpacity(0.3),
                              offset: Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/QTSharingdetail',
                                arguments: sharing['sharingId'],
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          sharing['title'],
                                          style: AppTypography.headline6.copyWith(
                                            color: AppColors.color2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.color5,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          sharing['userName'],
                                          style: AppTypography.body3.copyWith(
                                            color: AppColors.color3,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    sharing['content'],
                                    style: AppTypography.body2.copyWith(
                                      color: AppColors.color3,
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 8),
                  ],
                );
              },
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: AppColors.color4,
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.color3,
                ),
                SizedBox(height: 16),
                Text(
                  '데이터 로드 실패',
                  style: AppTypography.headline6.copyWith(
                    color: AppColors.color3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
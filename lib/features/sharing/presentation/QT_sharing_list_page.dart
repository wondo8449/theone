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
        backgroundColor: AppColors.color1,
        elevation: 0,
        title: Text(
          'QT 나눔 목록',
          style: AppTypography.headline3.copyWith(color: AppColors.color2),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.color2),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.color2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/QTwrite');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    '작성',
                    style: AppTypography.buttonLabelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.color4,
        onRefresh: () async {
          await ref.read(QTSharingProvider.notifier).refresh();
        },
        child: QTSharingList.when(
          data: (qtSharings) {
            if (qtSharings.isEmpty) {
              return Center(
                child: Container(
                  margin: EdgeInsets.all(32),
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.color6.withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 48,
                        color: AppColors.color3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'QT 나눔이 없습니다',
                        style: AppTypography.headline6.copyWith(
                          color: AppColors.color3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

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
                    // 날짜 헤더
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.color2,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.color6.withOpacity(0.2),
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        date,
                        style: AppTypography.headline5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // 해당 날짜의 QT 나눔 목록
                    ...dayItems.map((sharing) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.color6.withOpacity(0.2),
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
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.color2,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'QT',
                                          style: AppTypography.caption.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
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
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.color5,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          sharing['userName'],
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.color3,
                                            fontWeight: FontWeight.w600,
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
            child: Container(
              margin: EdgeInsets.all(32),
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
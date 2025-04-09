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
      appBar: AppBar(
        title: Text(
          'QT 나눔 목록',
          style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
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

            List<Widget> listItems = [];
            for (var date in sortedDates) {
              listItems.add(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    date,
                    style: AppTypography.headline5.copyWith(color: AppColors.primary_450),
                  ),
                ),
              );

              for (var sharing in groupedData[date]!) {
                listItems.add(
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/QTSharingdetail',
                        arguments: sharing['sharingId'],
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      margin: AppSpacing.small4,
                      child: Padding(
                        padding: AppSpacing.small12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(sharing['title'], style: AppTypography.headline6),
                                Text(sharing['userName'], style: AppTypography.body3),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              sharing['content'],
                              style: AppTypography.body2,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              listItems.add(SizedBox(height: 16));
            }

            return ListView(
              padding: AppSpacing.medium16,
              children: listItems,
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('데이터 로드 실패: $error')),
        ),
      ),
    );
  }
}

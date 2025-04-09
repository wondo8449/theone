import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import '../../../core/constants/app_border_radius.dart';
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
          title: Text('QT 나눔 목록', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
      body: RefreshIndicator(
        onRefresh: () async {
        await ref.read(QTSharingProvider.notifier).refresh();
        },
        child: Padding(
          padding: AppSpacing.medium16,
          child: ListView(
            children: [
              QTSharingList.when(
                data: (QTsharings) {
                  return Column(
                    children: QTsharings.map((QTSharing) {
                      String formattedDate = formatDate(QTSharing['createdAt']);
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/QTSharingdetail',
                            arguments: QTSharing['sharingId'],
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
                                    Text(QTSharing['title'], style: AppTypography.headline6),
                                    Text(
                                      "$formattedDate  ${QTSharing['userName']}",
                                      style: AppTypography.body3,
                                    ),
                                  ],
                                ),
                                Text(QTSharing['content'], style: AppTypography.body2, maxLines: 3),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('데이터 로드 실패: $error')),
              )
            ],
          )
        )
      )
    );
  }
}
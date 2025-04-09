import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import '../../../core/constants/app_border_radius.dart';
import 'package:theone/features/sharing/provider/sharing_provider.dart';

class InvitationSharingListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationSharingList = ref.watch(invitationSharingProvider);

    String formatDate(String timestamp) {
      DateTime date = DateTime.parse(timestamp);
      return DateFormat('yyyy년 M월 d일').format(date);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('풍삶초 나눔 목록', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)),
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
                    invitationSharingList.when(
                      data: (invitationSharings) {
                        return Column(
                          children: invitationSharings.map((invitationSharing) {
                            String formattedDate = formatDate(invitationSharing['createdAt']);
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/InvitationSharingDetail',
                                  arguments: invitationSharing['sharingId'],
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
                                          Text(invitationSharing['title'], style: AppTypography.headline6),
                                          Text(
                                            "$formattedDate  ${invitationSharing['userName']}",
                                            style: AppTypography.body3,
                                          ),
                                        ],
                                      ),
                                      Text(invitationSharing['content'], style: AppTypography.body2, maxLines: 3),
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
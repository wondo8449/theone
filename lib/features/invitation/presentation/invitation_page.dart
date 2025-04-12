import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_border_radius.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/invitation/provider/invitation_provider.dart';

import 'invitation_detail_page.dart';

class InvitationPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationList = ref.watch(invitationListProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
      await ref.read(invitationListProvider.notifier).refresh();
      },
      child: Padding(
        padding: AppSpacing.small8,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/invitationRegister');
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary_150),
                        minimumSize: WidgetStateProperty.all<Size>(Size(80, 35)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                        )),
                    child: Text('+ 작성하기', style: AppTypography.buttonLabelSmall.copyWith(color: AppColors.primary_450)))
              ]
            ),
            SizedBox(width: 16),
            Expanded(
              child: invitationList.when(
                data: (res) {
                  return ListView.builder(
                    itemCount: res.length,
                    itemBuilder: (context, index) {
                      final invitation = res[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/invitationDetail',
                            arguments: invitation['invitationId'],
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.small4),
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: AppSpacing.medium16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('이끄미 : ', style: AppTypography.body1),
                                    Text(invitation['userName'], style: AppTypography.body2.copyWith(color: AppColors.grayScale_550)),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text('따르미 : ', style: AppTypography.body1),
                                    Text(invitation['followerName'], style: AppTypography.body2.copyWith(color: AppColors.grayScale_550)),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text('진행상황 : ', style: AppTypography.body1),
                                    Text(invitation['progress'], style: AppTypography.body2.copyWith(color: AppColors.grayScale_550)),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text('시작일자 : ', style: AppTypography.body1),
                                    Text(invitation['startDate'], style: AppTypography.body2.copyWith(color: AppColors.grayScale_550)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('데이터 로드 실패: $error')),
              ),
            ),
          ],
        ),
      ),
    )
    );

  }
}
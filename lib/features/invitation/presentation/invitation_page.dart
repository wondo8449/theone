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
      backgroundColor: AppColors.color1,
      body: RefreshIndicator(
        color: AppColors.color4,
        onRefresh: () async {
          await ref.read(invitationListProvider.notifier).refresh();
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.color2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/invitationRegister');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 18, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            '작성하기',
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
              SizedBox(height: 16),
              Expanded(
                child: invitationList.when(
                  data: (res) {
                    if (res.isEmpty) {
                      return Center(
                        child: Container(
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
                                '등록된 풍삶초가 없습니다',
                                style: AppTypography.headline6.copyWith(
                                  color: AppColors.color3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: res.length,
                      itemBuilder: (context, index) {
                        final invitation = res[index];
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
                                  '/invitationDetail',
                                  arguments: invitation['invitationId'],
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
                                            color: AppColors.color5,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '이끄미',
                                            style: AppTypography.caption.copyWith(
                                              color: AppColors.color3,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          invitation['userName'],
                                          style: AppTypography.body1.copyWith(
                                            color: AppColors.color2,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getProgressColor(invitation['progress']),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            invitation['progress'],
                                            style: AppTypography.caption.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.color5,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '따르미',
                                            style: AppTypography.caption.copyWith(
                                              color: AppColors.color3,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          invitation['followerName'],
                                          style: AppTypography.body1.copyWith(
                                            color: AppColors.color2,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: AppColors.color3,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          '시작일: ${invitation['startDate']}',
                                          style: AppTypography.body3.copyWith(
                                            color: AppColors.color3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(String progress) {
    switch (progress) {
      case '진행중':
        return AppColors.color4;
      case '종료':
        return AppColors.color2;
      case '중단':
        return AppColors.red;
      default:
        return AppColors.color3;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/sharing/provider/sharing_provider.dart';
import '../../../core/constants/app_border_radius.dart';

class SharingPage extends ConsumerStatefulWidget {
  @override
  _SharingPageState createState() => _SharingPageState();
}

class _SharingPageState extends ConsumerState<SharingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    ref.read(QTSharingProvider.notifier).refresh();
    ref.read(invitationSharingProvider.notifier).refresh();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.read(QTSharingProvider.notifier).refresh();
      ref.read(invitationSharingProvider.notifier).refresh();
    }
  }

  String formatDate(String timestamp) {
    DateTime date = DateTime.parse(timestamp);
    return DateFormat('yyyy년 M월 d일').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final QTSharingList = ref.watch(QTSharingProvider);
    final invitationSharingList = ref.watch(invitationSharingProvider);

    return Scaffold(
      backgroundColor: AppColors.color1,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(QTSharingProvider.notifier).refresh();
          await ref.read(invitationSharingProvider.notifier).refresh();
        },
        child: Padding(
          padding: AppSpacing.medium16,
          child: ListView(
            children: [
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.color2,
                        borderRadius: AppBorderRadius.medium16,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/QTwrite');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.medium16,
                          ),
                        ),
                        child: Text(
                          '+ QT 나눔 쓰기',
                          style: AppTypography.buttonLabelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.color4,
                        borderRadius: AppBorderRadius.medium16,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/invitationWrite');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.medium16,
                          ),
                        ),
                        child: Text(
                          '+ 풍삶초 나눔 쓰기',
                          style: AppTypography.buttonLabelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // QT 나눔 섹션
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'QT 나눔',
                          style: AppTypography.headline4.copyWith(
                            color: AppColors.color2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/QTSharingList');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.color3,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            '더보기',
                            style: AppTypography.buttonLabelSmall.copyWith(
                              color: AppColors.color3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    QTSharingList.when(
                      data: (QTsharings) {
                        return Column(
                          children: QTsharings.take(3).map((QTSharing) {
                            String formattedDate = formatDate(QTSharing['createdAt']);
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: AppColors.color5,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/QTSharingdetail',
                                      arguments: QTSharing['sharingId'],
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                QTSharing['title'],
                                                style: AppTypography.headline6.copyWith(
                                                  color: AppColors.color2,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              "${QTSharing['userName']}",
                                              style: AppTypography.body3.copyWith(
                                                color: AppColors.color3,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          QTSharing['content'],
                                          style: AppTypography.body2.copyWith(
                                            color: AppColors.color3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          formattedDate,
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.color4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.color4,
                          ),
                        ),
                      ),
                      error: (error, stack) => Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            '데이터 로드 실패',
                            style: TextStyle(color: AppColors.color3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // 풍삶초 나눔 섹션
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '풍삶초 나눔',
                          style: AppTypography.headline4.copyWith(
                            color: AppColors.color2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/invitationSharingList');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.color3,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            '더보기',
                            style: AppTypography.buttonLabelSmall.copyWith(
                              color: AppColors.color3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    invitationSharingList.when(
                      data: (invitationSharings) {
                        return Column(
                          children: invitationSharings.take(3).map((invitationSharing) {
                            String formattedDate = formatDate(invitationSharing['createdAt']);
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: AppColors.color5,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/InvitationSharingDetail',
                                      arguments: invitationSharing['sharingId'],
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                invitationSharing['title'],
                                                style: AppTypography.headline6.copyWith(
                                                  color: AppColors.color2,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              "${invitationSharing['userName']}",
                                              style: AppTypography.body3.copyWith(
                                                color: AppColors.color3,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          invitationSharing['content'],
                                          style: AppTypography.body2.copyWith(
                                            color: AppColors.color3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          formattedDate,
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.color4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.color4,
                          ),
                        ),
                      ),
                      error: (error, stack) => Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            '데이터 로드 실패',
                            style: TextStyle(color: AppColors.color3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
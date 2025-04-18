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
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(QTSharingProvider.notifier).refresh();
          await ref.read(invitationSharingProvider.notifier).refresh();
        },
        child: Padding(
          padding: AppSpacing.medium16,
          child: ListView(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/QTwrite');
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary_150),
                      minimumSize: WidgetStateProperty.all<Size>(Size(100, 35)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                      ),
                    ),
                    child: Text('+ QT 나눔 쓰기', style: AppTypography.buttonLabelSmall.copyWith(color: AppColors.primary_450)),
                  ),
                  SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/invitationWrite');
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary_150),
                      minimumSize: WidgetStateProperty.all<Size>(Size(100, 35)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                      ),
                    ),
                    child: Text('+ 풍삶초 나눔 쓰기', style: AppTypography.buttonLabelSmall.copyWith(color: AppColors.primary_450)),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('QT 나눔', style: AppTypography.headline4),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/QTSharingList');
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all<Size>(Size(30, 20)),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                          ),
                        ),
                        child: Text('+ 더보기', style: AppTypography.buttonLabelSmall.copyWith(color: AppColors.grayScale_850)),
                      ),
                    ],
                  ),
                  QTSharingList.when(
                    data: (QTsharings) {
                      return Column(
                        children: QTsharings.take(3).map((QTSharing) {
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
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('풍삶초 나눔', style: AppTypography.headline4),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/invitationSharingList');
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all<Size>(Size(30, 20)),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                          ),
                        ),
                        child: Text('+ 더보기', style: AppTypography.buttonLabelSmall.copyWith(color: AppColors.grayScale_850)),
                      ),
                    ],
                  ),
                  invitationSharingList.when(
                    data: (invitationSharings) {
                      return Column(
                        children: invitationSharings.take(3).map((invitationSharing) {
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

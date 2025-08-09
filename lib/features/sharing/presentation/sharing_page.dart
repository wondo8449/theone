import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/sharing/provider/sharing_provider.dart';

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
        color: AppColors.color4,
        onRefresh: () async {
          await ref.read(QTSharingProvider.notifier).refresh();
          await ref.read(invitationSharingProvider.notifier).refresh();
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // 작성 버튼 영역
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.color2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/QTwrite');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 18, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'QT 나눔 쓰기',
                              style: AppTypography.buttonLabelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.color4,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/invitationWrite');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 18, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              '풍삶초 나눔 쓰기',
                              style: AppTypography.buttonLabelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    // QT 나눔 섹션
                    Container(
                      padding: EdgeInsets.all(20),
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
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.color5,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton(
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
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          QTSharingList.when(
                            data: (QTsharings) {
                              if (QTsharings.isEmpty) {
                                return Container(
                                  padding: EdgeInsets.all(32),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.book_outlined,
                                        size: 48,
                                        color: AppColors.color3,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'QT 나눔이 없습니다',
                                        style: AppTypography.body1.copyWith(
                                          color: AppColors.color3,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Column(
                                children: QTsharings.take(3).map((QTSharing) {
                                  String formattedDate = formatDate(QTSharing['createdAt']);
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.color5,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.color6.withOpacity(0.1),
                                          offset: Offset(0, 1),
                                          blurRadius: 4,
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
                                            arguments: QTSharing['sharingId'],
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
                                                    QTSharing['userName'],
                                                    style: AppTypography.body3.copyWith(
                                                      color: AppColors.color3,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                QTSharing['content'],
                                                style: AppTypography.body2.copyWith(
                                                  color: AppColors.color3,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 16,
                                                    color: AppColors.color4,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    formattedDate,
                                                    style: AppTypography.caption.copyWith(
                                                      color: AppColors.color4,
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
                                }).toList(),
                              );
                            },
                            loading: () => Container(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.color4,
                                ),
                              ),
                            ),
                            error: (error, stack) => Container(
                              padding: EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: AppColors.color3,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '데이터 로드 실패',
                                    style: AppTypography.body1.copyWith(
                                      color: AppColors.color3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // 풍삶초 나눔 섹션
                    Container(
                      padding: EdgeInsets.all(20),
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
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.color5,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton(
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
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          invitationSharingList.when(
                            data: (invitationSharings) {
                              if (invitationSharings.isEmpty) {
                                return Container(
                                  padding: EdgeInsets.all(32),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.people_outline,
                                        size: 48,
                                        color: AppColors.color3,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        '풍삶초 나눔이 없습니다',
                                        style: AppTypography.body1.copyWith(
                                          color: AppColors.color3,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Column(
                                children: invitationSharings.take(3).map((invitationSharing) {
                                  String formattedDate = formatDate(invitationSharing['createdAt']);
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.color5,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.color6.withOpacity(0.1),
                                          offset: Offset(0, 1),
                                          blurRadius: 4,
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
                                            '/InvitationSharingDetail',
                                            arguments: invitationSharing['sharingId'],
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
                                                      color: AppColors.color4,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      '풍삶초',
                                                      style: AppTypography.caption.copyWith(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
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
                                                    invitationSharing['userName'],
                                                    style: AppTypography.body3.copyWith(
                                                      color: AppColors.color3,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                invitationSharing['content'],
                                                style: AppTypography.body2.copyWith(
                                                  color: AppColors.color3,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 16,
                                                    color: AppColors.color4,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    formattedDate,
                                                    style: AppTypography.caption.copyWith(
                                                      color: AppColors.color4,
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
                                }).toList(),
                              );
                            },
                            loading: () => Container(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.color4,
                                ),
                              ),
                            ),
                            error: (error, stack) => Container(
                              padding: EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: AppColors.color3,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '데이터 로드 실패',
                                    style: AppTypography.body1.copyWith(
                                      color: AppColors.color3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40), // 하단 여백
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
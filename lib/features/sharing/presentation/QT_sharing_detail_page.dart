
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/sharing_provider.dart';
import 'package:flutter/cupertino.dart';

class QTSharingDetailPage extends ConsumerStatefulWidget {
  @override
  _QTSharingDetailPageState createState() => _QTSharingDetailPageState();
}

class _QTSharingDetailPageState extends ConsumerState<QTSharingDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    final authState = ref.watch(authProvider);
    final loginId = authState['loginId'];
    final QTDetail = ref.watch(sharingDetailProvider(id));

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
          'QT 나눔',
          style: AppTypography.headline3.copyWith(
            color: AppColors.color2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.color2),
        actions: [
          QTDetail.when(
            data: (data) {
              final QTData = data as Map<String, dynamic>;
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: AppColors.color2),
                color: Colors.white,
                onSelected: (value) => _handleMenuSelection(context, value, QTData, ref),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'report',
                      child: Text(
                        '신고하기',
                        style: TextStyle(color: AppColors.color3),
                      ),
                    ),
                    if (loginId == QTData['userName'])
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          '삭제하기',
                          style: TextStyle(color: AppColors.color3),
                        ),
                      ),
                  ];
                },
              );
            },
            loading: () => SizedBox.shrink(),
            error: (error, stack) => SizedBox.shrink(),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: QTDetail.when(
          data: (data) {
            final QTData = data as Map<String, dynamic>;

            if (!isInitialized) {
              titleController.text = QTData['title'] ?? '';
              contentController.text = QTData['content'] ?? '';
              isInitialized = true;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '제목',
                      style: AppTypography.headline5.copyWith(
                        color: AppColors.color2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.color5,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: titleController,
                        enabled: loginId == QTData['userName'],
                        style: AppTypography.body1.copyWith(
                          color: AppColors.color2,
                        ),
                        decoration: InputDecoration(
                          hintText: '제목을 입력해주세요.',
                          hintStyle: TextStyle(color: AppColors.color3),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      '내용',
                      style: AppTypography.headline5.copyWith(
                        color: AppColors.color2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.color5,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: contentController,
                        enabled: loginId == QTData['userName'],
                        maxLines: 15,
                        minLines: 15,
                        style: AppTypography.body1.copyWith(
                          color: AppColors.color2,
                          height: 1.4,
                        ),
                        decoration: InputDecoration(
                          hintText: '내용을 입력해주세요.',
                          hintStyle: TextStyle(color: AppColors.color3),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.color6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '작성자',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.color3,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                QTData['userName'],
                                style: AppTypography.body2.copyWith(
                                  color: AppColors.color2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '작성일',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.color3,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatDate(QTData['createdAt']),
                                style: AppTypography.body2.copyWith(
                                  color: AppColors.color2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (loginId == QTData['userName']) ...[
                      SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.color2,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextButton(
                          onPressed: () {
                            final title = titleController.text;
                            final content = contentController.text;

                            if (title.isEmpty) {
                              _showErrorDialog(context, '제목을 입력해주세요.');
                              return;
                            }

                            if (content.isEmpty) {
                              _showErrorDialog(context, '내용을 입력해주세요.');
                              return;
                            }

                            final data = {'title': title, 'content': content};

                            ref.read(modifySharingDataProvider((id, data)).future).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '수정이 완료되었습니다.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors.color4,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }).catchError((error) {
                              print('수정 실패: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '수정에 실패했습니다.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors.color3,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            '수정하기',
                            style: AppTypography.buttonLabelMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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

  void _handleMenuSelection(
      BuildContext context, String value, Map<String, dynamic> data, WidgetRef ref) {
    final int id = data['sharingId'];

    if (value == 'report') {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            '신고하기',
            style: TextStyle(color: AppColors.color2),
          ),
          content: Text(
            '해당 나눔을 신고하시겠습니까?',
            style: TextStyle(color: AppColors.color3),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '취소',
                style: TextStyle(color: AppColors.color3),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                navigator.pop();

                try {
                  await ref.read(declarationSharingProvider(id).future);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        '신고가 접수되었습니다.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppColors.color4,
                    ),
                  );
                } catch (e) {
                  print('신고 실패: $e');
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        '신고에 실패했습니다.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppColors.color3,
                    ),
                  );
                }
              },
              isDestructiveAction: true,
              child: Text(
                '신고',
                style: TextStyle(color: AppColors.color2),
              ),
            ),
          ],
        ),
      );
    } else if (value == 'delete') {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            '삭제하기',
            style: TextStyle(color: AppColors.color2),
          ),
          content: Text(
            '정말 삭제하시겠습니까?\n삭제 후 되돌릴 수 없습니다.',
            style: TextStyle(color: AppColors.color3),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '취소',
                style: TextStyle(color: AppColors.color3),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await ref.read(deleteSharingProvider(id).future);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '삭제가 완료되었습니다.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppColors.color4,
                    ),
                  );

                  Navigator.pop(context);
                } catch (e) {
                  print('삭제 실패: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '삭제에 실패했습니다.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppColors.color3,
                    ),
                  );
                }
              },
              isDestructiveAction: true,
              child: Text(
                '삭제',
                style: TextStyle(color: AppColors.color2),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '알림',
            style: AppTypography.headline5.copyWith(
              color: AppColors.color2,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: AppTypography.body1.copyWith(
              color: AppColors.color3,
            ),
          ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: AppColors.color3,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
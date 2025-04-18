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
      appBar: AppBar(
        title: Text('QT 나눔', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          QTDetail.when(
            data: (data) {
              final QTData = data as Map<String, dynamic>;
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: AppColors.grayScale_950),
                onSelected: (value) => _handleMenuSelection(context, value, QTData, ref),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'report',
                      child: Text('신고하기'),
                    ),
                    if (loginId == QTData['userName'])
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('삭제하기'),
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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: QTDetail.when(
            data: (data) {
              final QTData = data as Map<String, dynamic>;

              if (!isInitialized) {
                titleController.text = QTData['title'] ?? '';
                contentController.text = QTData['content'] ?? '';
                isInitialized = true;
              }

              return ListView(
                children: [
                  Text('제목', style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
                  if (loginId == QTData['userName'])
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: '제목을 입력해주세요.',
                        enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.zero)),
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  if (loginId != QTData['userName'])
                    TextField(
                      controller: titleController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: '제목을 입력해주세요.',
                        enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.zero)),
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  SizedBox(height: 16),
                  Text('내용', style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
                  SizedBox(height: 16),
                  if (loginId == QTData['userName'])
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        hintText: '내용을 입력해주세요.',
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      maxLines: 15,
                      minLines: 15,
                      style: AppTypography.body1.copyWith(color: AppColors.grayScale_750),
                    ),
                  if (loginId != QTData['userName'])
                    TextField(
                      controller: contentController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: '내용을 입력해주세요.',
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                      ),
                      maxLines: 15,
                      minLines: 15,
                      style: AppTypography.body1.copyWith(color: AppColors.grayScale_750),
                    ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('작성자 : ' + QTData['userName'], style: AppTypography.headline5.copyWith(color: AppColors.grayScale_550)),
                      Text('작성일 : ' + formatDate(QTData['createdAt']), style: AppTypography.headline5.copyWith(color: AppColors.grayScale_550)),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (loginId == QTData['userName'])
                    ElevatedButton(
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
                              content: Text('수정이 완료되었습니다.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }).catchError((error) {
                          print('수정 실패: $error');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('수정에 실패했습니다.'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        });
                      },
                      child: Text('수정하기'),
                    ),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('데이터 로드 실패: $error')),
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
          title: Text('신고하기'),
          content: Text('해당 나눔을 신고하시겠습니까?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                navigator.pop();

                try {
                  await ref.read(declarationSharingProvider(id).future);
                  messenger.showSnackBar(
                    SnackBar(content: Text('신고가 접수되었습니다.')),
                  );
                } catch (e) {
                  print('신고 실패: $e');
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('신고에 실패했습니다.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              isDestructiveAction: true,
              child: Text('신고'),
            ),
          ],
        ),
      );
    } else if (value == 'delete') {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('삭제하기'),
          content: Text('정말 삭제하시겠습니까?\n삭제 후 되돌릴 수 없습니다.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await ref.read(deleteSharingProvider(id).future);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('삭제가 완료되었습니다.')),
                  );

                  Navigator.pop(context);
                } catch (e) {
                  print('삭제 실패: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('삭제에 실패했습니다.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              isDestructiveAction: true,
              child: Text('삭제'),
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
          title: Text('알림'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

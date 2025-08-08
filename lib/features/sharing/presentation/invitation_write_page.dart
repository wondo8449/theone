import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_typography.dart';
import '../provider/sharing_provider.dart';

class InvitationWritePage extends ConsumerStatefulWidget {
  @override
  _InvitationWritePageState createState() => _InvitationWritePageState();
}

class _InvitationWritePageState extends ConsumerState<InvitationWritePage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

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
    return Scaffold(
      backgroundColor: AppColors.color1,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '풍삶초 나눔 작성',
          style: AppTypography.headline3.copyWith(
            color: AppColors.color2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.color2),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
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
                SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.color2,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final title = titleController.text.trim();
                      final content = contentController.text.trim();

                      if (title.isEmpty) {
                        _showErrorDialog(context, '제목을 입력해주세요.');
                        return;
                      }

                      if (content.isEmpty) {
                        _showErrorDialog(context, '내용을 입력해주세요.');
                        return;
                      }

                      final data = {
                        'title': title,
                        'content': content,
                        'sectionCode': "INVITATION"
                      };

                      try {
                        final result = await ref.read(sendSharingDataProvider(data).future);

                        if (result.containsKey('sharingId')) {
                          final int id = result['sharingId'];
                          _showSuccessDialog(context, id);
                        } else {
                          _showErrorDialog(context, '저장된 데이터가 없습니다.');
                        }
                      } catch (error) {
                        _showErrorDialog(context, '저장에 실패했습니다.');
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      '저장하기',
                      style: AppTypography.buttonLabelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '저장 완료',
            style: AppTypography.headline5.copyWith(
              color: AppColors.color2,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '풍삶초 나눔이 저장되었습니다.',
            style: AppTypography.body1.copyWith(
              color: AppColors.color3,
            ),
          ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: AppColors.color4,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Future.microtask(() {
                    Navigator.of(context).pushReplacementNamed(
                      '/InvitationSharingDetail',
                      arguments: id,
                    );
                  });
                },
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
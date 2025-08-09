import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_typography.dart';
import '../provider/sharing_provider.dart';

class QTWritePage extends ConsumerStatefulWidget {
  @override
  _QTWritePageState createState() => _QTWritePageState();
}

class _QTWritePageState extends ConsumerState<QTWritePage> {
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
        backgroundColor: AppColors.color1,
        elevation: 0,
        title: Text(
          'QT 나눔 작성',
          style: AppTypography.headline3.copyWith(color: AppColors.color2),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.color2),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목 섹션
                Text(
                  '제목',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.color3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  style: AppTypography.body1.copyWith(color: AppColors.color2),
                  decoration: InputDecoration(
                    hintText: '제목을 입력해주세요.',
                    hintStyle: AppTypography.body2.copyWith(color: AppColors.color3),
                    filled: true,
                    fillColor: AppColors.color5,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.color2, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                SizedBox(height: 20),

                // 내용 섹션
                Text(
                  '내용',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.color3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: contentController,
                  maxLines: 15,
                  minLines: 15,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.color2,
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintText: 'QT 나눔 내용을 입력해주세요.\n\n예시:\n- 오늘 묵상한 말씀\n- 받은 은혜나 깨달음\n- 기도제목이나 감사제목',
                    hintStyle: AppTypography.body2.copyWith(
                      color: AppColors.color3,
                      height: 1.4,
                    ),
                    filled: true,
                    fillColor: AppColors.color5,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.color2, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                SizedBox(height: 32),

                // 저장 버튼
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.color2,
                    borderRadius: BorderRadius.circular(12),
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
                        'sectionCode': "QT"
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
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
            'QT 나눔이 성공적으로 저장되었습니다.',
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
                      '/QTSharingdetail',
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
                color: AppColors.red,
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
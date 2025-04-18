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
    ref.read(sharingFormProvider.notifier).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('풍삶초 나눔 작성', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)), centerTitle: true, automaticallyImplyLeading:true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('제목', style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: '제목을 입력해주세요.'),
            ),
            SizedBox(height: 16),
            Text('내용', style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: '내용을 입력해주세요.',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 17,
              minLines: 17,
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
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

                final data = {'title': title, 'content': content, 'sectionCode': "INVITATION"};

                final result = await ref.read(sendSharingDataProvider(data).future);

                if (result.containsKey('sharingId')) {
                  final int id = result['sharingId'];

                  _showSuccessDialog(context, id);
                } else {
                  _showErrorDialog(context, '저장된 데이터가 없습니다.');
                }
              },
              child: Text('저장하기'),
            ),
          ],
        ),
      ),
      )
    );
  }

  void _showSuccessDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('저장 완료'),
          content: Text('풍삶초 나눔이 저장되었습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Future.microtask(() {
                  Navigator.of(context).pushReplacementNamed(
                    '/InvitationSharingDetail',
                    arguments: id,
                  );
                });
              },
              child: Text('확인'),
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
          title: Text('알림'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
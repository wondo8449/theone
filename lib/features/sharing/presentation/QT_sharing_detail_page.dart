import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/sharing_provider.dart';

class QTSharingDetailPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    final authState = ref.watch(authProvider);
    final token = authState['token'];

    String formatDate(String timestamp) {
      DateTime date = DateTime.parse(timestamp);
      return DateFormat('yyyy년 M월 d일').format(date);
    }

    String loginId = "";
    if (token != null && token.isNotEmpty) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        loginId = decodedToken['sub'] ?? "";
      } catch (e) {
        loginId = "토큰 오류";
      }
    }

    final QTDetail = ref.watch(sharingDetailProvider(id));
    final titleController = ref.watch(titleControllerProvider);
    final contentController = ref.watch(contentControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('QT 나눔', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
        padding: EdgeInsets.all(16),
        child: QTDetail.when(
          data: (data) {
            final QTData = data as Map<String, dynamic>;

            titleController.text = QTData['title'] ?? '';
            contentController.text = QTData['content'] ?? '';

            return ListView(
              children: [
                Text('제목', style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: '제목을 입력해주세요.'),
                ),
                SizedBox(height: 16),
                Text('내용', style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('작성자 : ' + QTData['userName'], style: AppTypography.headline5.copyWith(color: AppColors.grayScale_550)),
                    Text('작성일 : ' + formatDate(QTData['createdAt']), style: AppTypography.headline5.copyWith(color: AppColors.grayScale_550))
                  ],
                ),
                SizedBox(height: 16),
                if(loginId == QTData['userName'])
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

                    final data = {'id': id, 'title': title, 'content': content, 'sectionCode': "INVITATION"};
                    ref.read(sendSharingDataProvider(data));
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
    )
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
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

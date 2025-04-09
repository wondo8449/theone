import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:theone/core/constants/app_border_radius.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/sharing_provider.dart';

class InvitationSharingDetailPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    final authState = ref.watch(authProvider);
    final loginId = authState['loginId'];

    String formatDate(String timestamp) {
      DateTime date = DateTime.parse(timestamp);
      return DateFormat('yyyy년 M월 d일').format(date);
    }

    final invitationDetail = ref.watch(sharingDetailProvider(id));
    final titleController = ref.watch(titleControllerProvider);
    final contentController = ref.watch(contentControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('풍삶초 나눔', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          invitationDetail.when(
            data: (data) {
              final invitationData = data as Map<String, dynamic>;
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: AppColors.grayScale_950),
                onSelected: (value) =>
                    _handleMenuSelection(context, value, invitationData, ref),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(value: 'report', child: Text('신고하기')),
                    if (loginId == invitationData['userName'])
                      PopupMenuItem(value: 'delete', child: Text('삭제하기')),
                  ];
                },
              );
            },
            loading: () => SizedBox.shrink(),
            error: (error, stack) => SizedBox.shrink(),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: invitationDetail.when(
            data: (data) {
              final invitationData = data as Map<String, dynamic>;

              titleController.text = invitationData['title'] ?? '';
              contentController.text = invitationData['content'] ?? '';

              return ListView(
                children: [
                  Text('제목',
                      style: AppTypography.headline5
                          .copyWith(color: AppColors.primary_450)),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: '제목을 입력해주세요.',
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('내용',
                      style: AppTypography.headline5
                          .copyWith(color: AppColors.primary_450)),
                  SizedBox(height: 16),
                  if (loginId == invitationData['userName'])
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        hintText: '내용을 입력해주세요.',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 12.0),
                        disabledBorder: InputBorder.none,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      maxLines: 15,
                      minLines: 15,
                      style: AppTypography.body1
                          .copyWith(color: AppColors.grayScale_750),
                    ),
                  if (loginId != invitationData['userName'])
                    TextField(
                      controller: contentController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: '내용을 입력해주세요.',
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 12.0),
                      ),
                      maxLines: 15,
                      minLines: 15,
                      style: AppTypography.body1
                          .copyWith(color: AppColors.grayScale_750),
                    ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('작성자 : ${invitationData['userName']}',
                          style: AppTypography.headline5
                              .copyWith(color: AppColors.grayScale_550)),
                      Text('작성일 : ${formatDate(invitationData['createdAt'])}',
                          style: AppTypography.headline5
                              .copyWith(color: AppColors.grayScale_550)),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (loginId == invitationData['userName'])
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

                        final data = {
                          'id': id,
                          'title': title,
                          'content': content,
                          'sectionCode': "INVITATION"
                        };
                        ref.read(sendSharingDataProvider(data));
                      },
                      child: Text('수정하기'),
                    ),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                Center(child: Text('데이터 로드 실패: $error')),
          ),
        ),
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value,
      Map<String, dynamic> data, WidgetRef ref) {
    if (value == 'report') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('신고하기'),
          content: Text('해당 나눔을 신고하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: 신고 API 연동
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('신고가 접수되었습니다.')));
              },
              child: Text('신고'),
            ),
          ],
        ),
      );
    } else if (value == 'delete') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('삭제하기'),
          content: Text('정말 삭제하시겠습니까? 삭제 후 되돌릴 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: 삭제 API 연동
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('삭제가 완료되었습니다.')));
                Navigator.pop(context); // 뒤로 가기
              },
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

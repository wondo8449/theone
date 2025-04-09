import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_border_radius.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/tree/provider/tree_provider.dart';
import '../../auth/provider/auth_provider.dart';

class TreePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeComments = ref.watch(treeCommentsProvider);
    final selectedYearMonth = ref.watch(yearMonthProvider);
    final selectedSearchValue = ref.watch(searchValueProvider);
    final commentEdits = ref.watch(commentEditProvider);
    final authState = ref.watch(authProvider);
    final role = authState['role'];


    if(role == "USER") {
      return Scaffold(
          body: Padding(
            padding: AppSpacing.small8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text('권한이 없습니다.')
                )
              ]
            )
          )
      );
    } else {
      return Scaffold(
        body: Padding(
          padding: AppSpacing.small8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: DropdownButton<String>(
                    value: selectedYearMonth,
                    style: AppTypography.buttonLabelXSmall.copyWith(color: AppColors.grayScale_850),
                    items: ['202502', '202503', '202504', '202505', '202506']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        ref.read(yearMonthProvider.notifier).state = newValue;
                      }
                    },
                  ),
                ),
              ),
              if(role == "ADMIN" || role == "DIRECTOR")
                Align(
                  alignment: Alignment.centerRight,
                  child: DropdownButton<String>(
                    value: selectedSearchValue,
                    style: AppTypography.buttonLabelXSmall.copyWith(color: AppColors.grayScale_850),
                    items: ['고요나무', '박예나무', '소윤나무', '수현나무', '승현나무', '시야나무', '예찬나무', '오예나무', '유요나무', '이현나무', '지현나무', '지훈나무']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        ref.read(searchValueProvider.notifier).state = newValue;
                      }
                    },
                  ),
                ),
              SizedBox(height: 8),

              Expanded(
                child: treeComments.when(
                  data: (comments) {
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final isEditing = commentEdits.containsKey(comment['commentId']);
                        final controller = ref.watch(commentEditControllerProvider(comment['commentId']));

                        if (isEditing && controller.text.isEmpty) {
                          controller.text = commentEdits[comment['commentId']] ?? comment['comment'];
                          controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: controller.text.length),
                          );
                        }

                        return Card(
                          color: Colors.white,
                          margin: AppSpacing.small4,
                          child: Padding(
                            padding: AppSpacing.small12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['userName'],
                                  style: AppTypography.headline5,
                                ),
                                SizedBox(height: 8),
                                isEditing
                                    ? TextField(
                                  controller: controller,
                                  maxLines: null,
                                  decoration: InputDecoration(border: OutlineInputBorder()),
                                  onChanged: (value) {
                                    ref.read(commentEditProvider.notifier).state = {
                                      ...commentEdits,
                                      comment['commentId']: value,
                                    };
                                  },
                                )
                                    : Text(comment['comment'], style: AppTypography.body1.copyWith(color: AppColors.grayScale_550)),
                                SizedBox(height: 8),
                                if(role == "LEADER")
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (isEditing)
                                        TextButton(
                                          onPressed: () async {
                                            final newComment = controller.text;
                                            await ref.read(treeRepositoryProvider).editComment(comment['commentId'], newComment);
                                            ref.read(commentEditProvider.notifier).state = {};
                                            ref.refresh(treeCommentsProvider);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary_450),
                                              minimumSize: WidgetStateProperty.all<Size>(Size(45, 30)),
                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                                              )),
                                          child: Text('저장', style: AppTypography.buttonLabelSmall.copyWith(color: Colors.white)),
                                        )
                                      else
                                        TextButton(
                                          onPressed: () {
                                            ref.read(commentEditProvider.notifier).state = {
                                              ...commentEdits,
                                              comment['commentId']: comment['comment'],
                                            };
                                            ref.read(commentEditControllerProvider(comment['commentId']).notifier).state =
                                                TextEditingController(text: comment['comment']);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary_450),
                                              minimumSize: WidgetStateProperty.all<Size>(Size(45, 30)),
                                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                                              )),
                                          child: Text('수정', style: AppTypography.buttonLabelSmall.copyWith(color: Colors.white)),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('데이터 로드 실패: $error')),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

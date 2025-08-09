import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_colors.dart';
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

    if (role == "USER") {
      return Scaffold(
        backgroundColor: AppColors.color1,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(32),
            margin: EdgeInsets.all(24),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.color5,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: AppColors.color3,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '접근 권한이 없습니다',
                  style: AppTypography.headline4.copyWith(
                    color: AppColors.color2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '나무 관리는 나무장 이상의 권한이 필요합니다',
                  style: AppTypography.body1.copyWith(
                    color: AppColors.color3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.color1,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 필터 카드
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.eco,
                        color: AppColors.color4,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '나무 관리',
                        style: AppTypography.headline5.copyWith(
                          color: AppColors.color2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          value: selectedYearMonth,
                          items: ['202502', '202503', '202504', '202505', '202506'],
                          onChanged: (newValue) {
                            if (newValue != null) {
                              ref.read(yearMonthProvider.notifier).state = newValue;
                            }
                          },
                          label: '기간 선택',
                        ),
                      ),
                      if (role == "ADMIN" || role == "DIRECTOR") ...[
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            value: selectedSearchValue,
                            items: [
                              '고요나무', '박예나무', '소윤나무', '수현나무', '승현나무',
                              '시야나무', '예찬나무', '오예나무', '유요나무', '이현나무',
                              '지현나무', '지훈나무'
                            ],
                            onChanged: (newValue) {
                              if (newValue != null) {
                                ref.read(searchValueProvider.notifier).state = newValue;
                              }
                            },
                            label: '나무 선택',
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 코멘트 목록
            Expanded(
              child: treeComments.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(32),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.eco_outlined,
                              size: 48,
                              color: AppColors.color3,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '등록된 코멘트가 없습니다',
                              style: AppTypography.headline6.copyWith(
                                color: AppColors.color3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

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

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.color6.withOpacity(0.2),
                              offset: Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 사용자 정보 헤더
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.color4,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.eco,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment['userName'],
                                          style: AppTypography.body1.copyWith(
                                            color: AppColors.color2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '나무원',
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.color3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (role == "LEADER" && !isEditing) ...[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.color2,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          ref.read(commentEditProvider.notifier).state = {
                                            ...commentEdits,
                                            comment['commentId']: comment['comment'],
                                          };
                                          ref.read(commentEditControllerProvider(comment['commentId']).notifier).state =
                                              TextEditingController(text: comment['comment']);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.edit, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              '수정',
                                              style: AppTypography.caption.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 16),

                              // 코멘트 내용
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isEditing ? AppColors.color5 : AppColors.color6.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: isEditing ? Border.all(color: AppColors.color2.withOpacity(0.3)) : null,
                                ),
                                child: isEditing
                                    ? TextField(
                                  controller: controller,
                                  maxLines: null,
                                  style: AppTypography.body1.copyWith(
                                    color: AppColors.color2,
                                    height: 1.5,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '코멘트를 입력해주세요...',
                                    hintStyle: AppTypography.body2.copyWith(color: AppColors.color3),
                                  ),
                                  onChanged: (value) {
                                    ref.read(commentEditProvider.notifier).state = {
                                      ...commentEdits,
                                      comment['commentId']: value,
                                    };
                                  },
                                )
                                    : Text(
                                  comment['comment'],
                                  style: AppTypography.body1.copyWith(
                                    color: AppColors.color2,
                                    height: 1.5,
                                  ),
                                ),
                              ),

                              // 편집 모드 버튼들
                              if (isEditing) ...[
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.color3,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          ref.read(commentEditProvider.notifier).state = {};
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          '취소',
                                          style: AppTypography.buttonLabelSmall.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.color4,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        onPressed: () async {
                                          final newComment = controller.text;
                                          if (newComment.trim().isNotEmpty) {
                                            await ref.read(treeRepositoryProvider).editComment(
                                                comment['commentId'],
                                                newComment
                                            );
                                            ref.read(commentEditProvider.notifier).state = {};
                                            ref.refresh(treeCommentsProvider);

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('코멘트가 수정되었습니다.'),
                                                backgroundColor: AppColors.color4,
                                              ),
                                            );
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          '저장',
                                          style: AppTypography.buttonLabelSmall.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.color4,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Container(
                    padding: EdgeInsets.all(32),
                    margin: EdgeInsets.all(24),
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
                      mainAxisSize: MainAxisSize.min,
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
                        SizedBox(height: 8),
                        Text(
                          '네트워크 연결을 확인해 주세요',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.color3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body2.copyWith(
            color: AppColors.color3,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.color5,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.color6.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: AppTypography.body1.copyWith(
                color: AppColors.color2,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: AppTypography.body1.copyWith(color: AppColors.color2),
                ),
              )).toList(),
              onChanged: onChanged,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.color3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
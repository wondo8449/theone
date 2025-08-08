import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/core/constants/app_border_radius.dart';
import 'package:theone/features/invitation/provider/invitation_provider.dart';
import 'invitation_detail_page.dart';

class InvitationRegisterPage extends ConsumerStatefulWidget {
  const InvitationRegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<InvitationRegisterPage> createState() => _InvitationRegisterPageState();
}

class _InvitationRegisterPageState extends ConsumerState<InvitationRegisterPage> {
  final _userNameController = TextEditingController();
  final _followerNameController = TextEditingController();
  bool _isInitialized = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _followerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressState = ref.watch(invitationStatusProvider);

    // 초기화
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(invitationEditControllerProvider.notifier).initializeEditData({
          'userName': '',
          'followerName': '',
          'startDate': null,
          'endDate': null,
          'progress': 0,
        });
      });
      _isInitialized = true;
    }

    final editController = ref.watch(invitationEditDataProvider);

    return Scaffold(
      backgroundColor: AppColors.color1,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        elevation: 0,
        title: Text(
          '풍삶초 등록',
          style: AppTypography.headline3.copyWith(color: AppColors.color2),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.color2),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // 기본 정보 카드
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '기본 정보',
                      style: AppTypography.headline5.copyWith(
                        color: AppColors.color2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    _textField('followerName', '따르미', _followerNameController),

                    Row(
                      children: [
                        Expanded(
                          child: DateField(
                            keyName: 'startDate',
                            label: '시작일자',
                            initialValue: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            ref: ref,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DateField(
                            keyName: 'endDate',
                            label: '종료일자',
                            initialValue: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            ref: ref,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      '진행상태',
                      style: AppTypography.body2.copyWith(
                        color: AppColors.color3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.color5,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: progressState,
                          onChanged: (String? value) {
                            if (value != null) {
                              ref.read(invitationStatusProvider.notifier).state = value;
                            }
                          },
                          style: AppTypography.body1.copyWith(color: AppColors.color2),
                          items: ['진행중', '종료', '중단']
                              .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // 상세 내용 카드
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '상세 내용',
                      style: AppTypography.headline5.copyWith(
                        color: AppColors.color2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    _editableField('meetingDate', '만남 일정', '매주 만나는 요일과 시간', '시작 시 작성'),
                    _editableField('followerExpectation', '따르미에 대한 기대', '풍삶초를 시작하며 따르미가 어떤 기대나 소망을 가지고 시작하는지', '시작 시 작성'),
                    _editableField('myExpectation', '이끄미로서의 기대', '풍삶초를 시작하며 이끄미로써 어떤 기대나 소망을 가지고 시작하는지', '시작 시 작성'),
                    _editableField('followerPray', '따르미 기도제목', '따르미의 기도제목', '시작 시 작성'),
                    _editableField('myPray', '이끄미 기도제목', '이끄미의 기도제목', '시작 시 작성'),
                    _editableField('followerChange', '따르미의 변화 과정', '풍삶초를 통한 따르미의 변화된 점, 새롭게 알게 된 내용이나 중요하게 생각하게 된 부분, 결심하게 된 부분', '4~5주차 작성'),
                    _editableField('myChange', '이끄미의 변화 과정', '중요하게 생각하게 된 내용, 따르미의 대화를 통하여 도전받은 부분, 결심하게 된 부분', '4~5주차 작성'),
                    _editableField('feedback', '풍삶초를 돌아보며', '1) 따르미의 성장 관찰\n2) 이끄미로서 배우고 느낀 점\n3) 풍삶초를 마무리하며 나누고 싶은 점', '종료 시 작성 (가장 중요)'),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.color2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    final updated = ref.read(invitationEditDataProvider);
                    final progressMap = {'진행중': 0, '종료': 1, '중단': 2};

                    final dataToSend = {
                      ...updated,
                      'userName': _userNameController.text,
                      'followerName': _followerNameController.text,
                      'progress': progressMap[progressState],
                    };

                    ref.read(createInvitationProvider(dataToSend).future).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('작성되었습니다.'),
                          backgroundColor: AppColors.color4,
                        ),
                      );
                      Navigator.pop(context);
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('작성 실패: $e'),
                          backgroundColor: AppColors.red,
                        ),
                      );
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '작성하기',
                    style: AppTypography.buttonLabelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(String key, String label, TextEditingController controller) {
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
        TextFormField(
          controller: controller,
          style: AppTypography.body1.copyWith(color: AppColors.color2),
          decoration: InputDecoration(
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
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _editableField(String key, String label, String description, String when) {
    final currentValue = ref.watch(invitationEditDataProvider)[key] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.body1.copyWith(
                color: AppColors.color2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.color4,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                when,
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: AppTypography.body3.copyWith(
            color: AppColors.color3,
            height: 1.4,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: currentValue,
          onChanged: (value) {
            ref.read(invitationEditControllerProvider.notifier).updateEditDataField(key, value);
          },
          minLines: 3,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          style: AppTypography.body2.copyWith(color: AppColors.color2),
          decoration: InputDecoration(
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
            contentPadding: EdgeInsets.all(12),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
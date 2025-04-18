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
      appBar: AppBar(
        title: Text('풍삶초 등록', style: AppTypography.headline3),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: AppSpacing.medium16,
          child: ListView(
            children: [
              _textField('followerName', '따르미', _followerNameController),
              Row(
                children: [
                  DateField(
                    keyName: 'startDate',
                    label: '시작일자',
                    initialValue: DateFormat('YYYY-MM-DD').format(DateTime.now()),
                    ref: ref,
                  ),
                  SizedBox(width: 30),
                  DateField(
                    keyName: 'endDate',
                    label: '종료일자',
                    initialValue: DateFormat('YYYY-MM-DD').format(DateTime.now()),
                    ref: ref,
                  ),
                ],
              ),
              Text('진행상태', style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
              DropdownButton<String>(
                value: progressState,
                onChanged: (String? value) {
                  if (value != null) {
                    ref.read(invitationStatusProvider.notifier).state = value;
                  }
                },
                items: ['진행중', '종료', '중단']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
              ),
              SizedBox(height: 20),
              _editableField('meetingDate', '만남 일정', '매주 만나는 요일과 시간', '시작 시 작성'),
              _editableField('followerExpectation', '따르미에 대한 기대', '풍삶초를 시작하며 따르미가 어떤 기대나 소망을 가지고 시작하는지', '시작 시 작성'),
              _editableField('myExpectation', '이끄미로서의 기대', '풍삶초를 시작하며 이끄미로써 어떤 기대나 소망을 가지고 시작하는지', '시작 시 작성'),
              _editableField('followerPray', '따르미 기도제목', '따르미의 기도제목', '시작 시 작성'),
              _editableField('myPray', '이끄미 기도제목', '이끄미의 기도제목', '시작 시 작성'),
              _editableField('followerChange', '따르미의 변화 과정', '풍삶초를 통한 따르미의 변화된 점, 새롭게 알게 된 내용이나 중요하게 생각하게 된 부분, 결심하게 된 부분', '4~5주차 작성'),
              _editableField('myChange', '이끄미의 변화 과정', '중요하게 생각하게 된 내용, 따르미의 대화를 통하여 도전받은 부분,  결심하게 된 부분 ', '4~5주차 작성'),
              _editableField('feedback', '풍삶초를 돌아보며', '1) 따르미의 성장 관찰 \n2) 이끄미로서 배우고 느낀 점 \n3) 풍삶초를 마무리하며 나누고 싶은 점', '종료 시 작성 (가장 중요)'),
              SizedBox(height: 20),
              ElevatedButton(
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
                      SnackBar(content: Text('작성되었습니다.')),
                    );
                    Navigator.pop(context);
                  }).catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('작성 실패: $e'), backgroundColor: Colors.red),
                    );
                  });
                },
                child: Text('작성하기'),
              ),
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
        Text(label, style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.grayScale_050,
            border: OutlineInputBorder(borderRadius: AppBorderRadius.small8),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
            SizedBox(width: 8),
            Text(when, style: AppTypography.body2.copyWith(color: AppColors.grayScale_450))
          ]
        ),
        SizedBox(height: 8),
        Text(description, style: AppTypography.body2.copyWith(color: AppColors.grayScale_450)),
        SizedBox(height: 8),
        TextFormField(
          initialValue: currentValue,
          onChanged: (value) {
            ref.read(invitationEditControllerProvider.notifier).updateEditDataField(key, value);
          },
          minLines: 3,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.grayScale_050,
            border: OutlineInputBorder(borderRadius: AppBorderRadius.small8),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

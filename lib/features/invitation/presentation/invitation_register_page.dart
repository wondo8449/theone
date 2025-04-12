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
              _editableField('meetingDate', '만남 일정'),
              _editableField('followerExpectation', '따르미에 대한 기대'),
              _editableField('myExpectation', '이끄미에 대한 기대'),
              _editableField('followerChange', '따르미 변화'),
              _editableField('myChange', '이끄미 변화'),
              _editableField('followerPray', '따르미 기도제목'),
              _editableField('myPray', '이끄미 기도제목'),
              _editableField('feedback', '느낀점'),
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

  Widget _editableField(String key, String label) {
    final currentValue = ref.watch(invitationEditDataProvider)[key] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
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

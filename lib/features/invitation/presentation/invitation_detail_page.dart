import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/invitation/provider/invitation_provider.dart';
import '../../../core/constants/app_border_radius.dart';
import '../../auth/provider/auth_provider.dart';

class InvitationDetailPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<InvitationDetailPage> createState() => _InvitationDetailPageState();
}

class _InvitationDetailPageState extends ConsumerState<InvitationDetailPage> {
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final int id = ModalRoute.of(context)!.settings.arguments as int;
    final authState = ref.watch(authProvider);
    final loginId = authState['loginId'];

    final invitationDetail = ref.watch(invitationDetailProvider(id));
    final progressState = ref.watch(invitationStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('풍삶초 상세', style: AppTypography.headline3),
        centerTitle: true,
      ),
      body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
        padding: AppSpacing.medium16,
        child: invitationDetail.when(
          data: (data) {
            // 딱 한 번만 초기화
            if (!_isInitialized) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(invitationEditControllerProvider.notifier).initializeEditData(data);
              });
              _isInitialized = true;
            }

            final editController = ref.watch(invitationEditControllerProvider);

            return ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _readOnlyField('이끄미', data['userName']),
                    SizedBox(width: 30),
                    _readOnlyField('따르미', data['followerName'])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DateField(
                      keyName: 'startDate',
                      label: '시작일자',
                      initialValue: data['startDate'],
                      ref: ref,
                    ),
                    SizedBox(width: 30),
                    DateField(
                      keyName: 'endDate',
                      label: '종료일자',
                      initialValue: data['endDate'],
                      ref: ref,
                    )
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
                _editableField(context, ref, 'meetingDate', '만남 일정', data['meetingDate']),
                _editableField(context, ref, 'followerExpectation', '따르미에 대한 기대', data['followerExpectation']),
                _editableField(context, ref, 'myExpectation', '이끄미에 대한 기대', data['myExpectation']),
                _editableField(context, ref, 'followerChange', '따르미 변화', data['followerChange']),
                _editableField(context, ref, 'myChange', '이끄미 변화', data['myChange']),
                _editableField(context, ref, 'followerPray', '따르미 기도제목', data['followerPray']),
                _editableField(context, ref, 'myPray', '이끄미 기도제목', data['myPray']),
                _editableField(context, ref, 'feedback', '느낀점', data['feedback']),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final updated = ref.read(invitationEditDataProvider);
                    final progressMap = {'진행중': 0, '종료': 1, '중단': 2};
                    final dataToSend = {
                      ...updated,
                      'invitationId': data['invitationId'],
                      'progress': progressMap[progressState],
                    };

                    ref.read(sendInvitationUpdateProvider((dataToSend, data['invitationId'])).future).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('저장되었습니다.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }).catchError((e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('저장에 실패했습니다.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  },
                  child: Text('수정하기'),
                ),

              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('오류 발생: $e')),
        ),
      ),
      )
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
        Text(value, style: AppTypography.body1),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _editableField(BuildContext context, WidgetRef ref, String key, String label, String initialValue) {
    final currentValue = ref.watch(invitationEditDataProvider)[key] ?? initialValue;

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
          scrollPhysics: BouncingScrollPhysics(),
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

class DateField extends StatefulWidget {
  final String keyName;
  final String label;
  final String initialValue;
  final WidgetRef ref;

  const DateField({
    required this.keyName,
    required this.label,
    required this.initialValue,
    required this.ref,
    super.key,
  });

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late DateTime selectedDate;
  late String displayText;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.tryParse(widget.initialValue) ?? DateTime.now();
    displayText = DateFormat('yyyy년 M월 d일').format(selectedDate);
  }

  void _updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      displayText = DateFormat('yyyy년 M월 d일').format(newDate);
    });

    final formatted = DateFormat('yyyy-MM-dd').format(newDate);
    widget.ref.read(invitationEditControllerProvider.notifier).updateEditDataField(widget.keyName, formatted);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (_) => Container(
                height: 300,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _updateDate(selectedDate);
                        },
                        child: Text('완료', style: TextStyle(color: AppColors.primary_450)),
                      ),
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: selectedDate,
                        onDateTimeChanged: (DateTime newDate) {
                          selectedDate = newDate; // setState는 완료 버튼 누를 때만
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.grayScale_050,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: AppBorderRadius.small8,
            ),
            child: Text(displayText, style: AppTypography.body1),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

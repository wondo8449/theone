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
  final Map<String, TextEditingController> _controllers = {};
  bool isInitialized = false;

  final List<String> fields = [
    'meetingDate',
    'followerExpectation',
    'myExpectation',
    'followerPray',
    'myPray',
    'followerChange',
    'myChange',
    'feedback',
  ];

  @override
  void initState() {
    super.initState();
    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }

    Future.microtask(() {
      final id = ModalRoute.of(context)!.settings.arguments as int;
      ref.listenManual(
        invitationDetailProvider(id),
            (previous, next) {
          next.whenData((invitationData) {
            if (!isInitialized) {
              for (var field in fields) {
                _controllers[field]?.text = invitationData[field] ?? '';
                // Edit 데이터도 함께 초기화
                ref.read(invitationEditControllerProvider.notifier)
                    .updateEditDataField(field, invitationData[field] ?? '');
              }

              // 날짜 필드도 초기화
              ref.read(invitationEditControllerProvider.notifier)
                  .updateEditDataField('startDate', invitationData['startDate'] ?? '');
              ref.read(invitationEditControllerProvider.notifier)
                  .updateEditDataField('endDate', invitationData['endDate'] ?? '');

              // 진행 상태도 초기화
              final progressMap = {0: '진행중', 1: '종료', 2: '중단'};
              final progress = invitationData['progress'];
              if (progressMap.containsKey(progress)) {
                ref.read(invitationStatusProvider.notifier).state = progressMap[progress]!;
              }

              isInitialized = true;
            }
          });
        },
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

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
                    if (loginId != invitationData['userName'])
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
        ]
      ),
      body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
        padding: AppSpacing.medium16,
        child: invitationDetail.when(
          data: (data) {
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
                _editableField(context, ref, 'meetingDate', '만남 일정', '매주 만나는 요일과 시간', '시작 시 작성', data['meetingDate']),
                _editableField(context, ref, 'followerExpectation', '따르미에 대한 기대', '풍삶초를 시작하며 따르미가 어떤 기대나 소망을 가지고 시작하는지', '시작 시 작성', data['followerExpectation']),
                _editableField(context, ref, 'myExpectation', '이끄미로서의 기대', '풍삶초를 시작하며 이끄미로써 어떤 기대나 소망을 가지고 시작하는지', '시작 시 작성', data['myExpectation']),
                _editableField(context, ref, 'followerPray', '따르미 기도제목', '따르미의 기도제목', '시작 시 작성', data['followerPray']),
                _editableField(context, ref, 'myPray', '이끄미 기도제목', '이끄미의 기도제목', '시작 시 작성', data['myPray']),
                _editableField(context, ref, 'followerChange', '따르미의 변화 과정', '풍삶초를 통한 따르미의 변화된 점, 새롭게 알게 된 내용이나 중요하게 생각하게 된 부분, 결심하게 된 부분', '4~5주차 작성', data['followerChange']),
                _editableField(context, ref, 'myChange', '이끄미의 변화 과정', '중요하게 생각하게 된 내용, 따르미의 대화를 통하여 도전받은 부분,  결심하게 된 부분 ', '4~5주차 작성', data['myChange']),
                _editableField(context, ref, 'feedback', '풍삶초를 돌아보며', '1) 따르미의 성장 관찰 \n2) 이끄미로서 배우고 느낀 점 \n3) 풍삶초를 마무리하며 나누고 싶은 점', '종료 시 작성 (가장 중요)', data['feedback']),
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

  void _handleMenuSelection(
      BuildContext context, String value, Map<String, dynamic> data, WidgetRef ref) {
    final int id = data['invitationId'];

    if (value == 'report') {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('신고하기'),
          content: Text('해당 나눔을 신고하시겠습니까?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await ref.read(deleteInvitationProvider(id).future);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('신고가 접수되었습니다.')),
                  );

                } catch(e) {
                  print('신고 실패: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('신고에 실패했습니다.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              isDestructiveAction: true,
              child: Text('신고'),
            ),
          ],
        ),
      );
    } else if (value == 'delete') {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('삭제하기'),
          content: Text('정말 삭제하시겠습니까?\n삭제 후 되돌릴 수 없습니다.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await ref.read(deleteInvitationProvider(id).future);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('삭제가 완료되었습니다.')),
                  );

                  Navigator.pop(context);
                } catch (error) {
                  print('삭제 실패: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('삭제에 실패했습니다.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              isDestructiveAction: true,
              child: Text('삭제'),
            ),
          ],
        ),
      );
    }
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

  Widget _editableField(
      BuildContext context,
      WidgetRef ref,
      String key,
      String label,
      String description,
      String when,
      String initialValue,
      ) {
    final controller = _controllers[key]!;

    // ⚠️ addListener 중복 방지: isInitialized 조건 체크
    if (isInitialized && !controller.hasListeners) {
      controller.addListener(() {
        ref.read(invitationEditControllerProvider.notifier)
            .updateEditDataField(key, controller.text);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
            SizedBox(width: 8),
            Text(when, style: AppTypography.body2.copyWith(color: AppColors.grayScale_450))
          ],
        ),
        SizedBox(height: 8),
        Text(description, style: AppTypography.body2.copyWith(color: AppColors.grayScale_450)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
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

    // ✅ 초기값 상태 반영
    final formatted = DateFormat('yyyy-MM-dd').format(selectedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.ref.read(invitationEditControllerProvider.notifier).updateEditDataField(widget.keyName, formatted);
    });
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
                          selectedDate = newDate;
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

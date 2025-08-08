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
                ref.read(invitationEditControllerProvider.notifier)
                    .updateEditDataField(field, invitationData[field] ?? '');
              }

              ref.read(invitationEditControllerProvider.notifier)
                  .updateEditDataField('startDate', invitationData['startDate'] ?? '');
              ref.read(invitationEditControllerProvider.notifier)
                  .updateEditDataField('endDate', invitationData['endDate'] ?? '');

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
      backgroundColor: AppColors.color1,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        elevation: 0,
        title: Text(
          '풍삶초 상세',
          style: AppTypography.headline3.copyWith(color: AppColors.color2),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.color2),
        actions: [
          invitationDetail.when(
            data: (data) {
              final invitationData = data as Map<String, dynamic>;
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: AppColors.color2),
                color: Colors.white,
                onSelected: (value) =>
                    _handleMenuSelection(context, value, invitationData, ref),
                itemBuilder: (BuildContext context) {
                  return [
                    if (loginId != invitationData['userName'])
                      PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(Icons.report_outlined, color: AppColors.red, size: 20),
                            SizedBox(width: 8),
                            Text('신고하기', style: TextStyle(color: AppColors.red)),
                          ],
                        ),
                      ),
                    if (loginId == invitationData['userName'])
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: AppColors.red, size: 20),
                            SizedBox(width: 8),
                            Text('삭제하기', style: TextStyle(color: AppColors.red)),
                          ],
                        ),
                      ),
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
        child: invitationDetail.when(
          data: (data) {
            return SingleChildScrollView(
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

                        Row(
                          children: [
                            Expanded(child: _readOnlyField('이끄미', data['userName'])),
                            SizedBox(width: 16),
                            Expanded(child: _readOnlyField('따르미', data['followerName'])),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: DateField(
                                keyName: 'startDate',
                                label: '시작일자',
                                initialValue: data['startDate'],
                                ref: ref,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: DateField(
                                keyName: 'endDate',
                                label: '종료일자',
                                initialValue: data['endDate'],
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

                  // 상세 내용 카드들
                  ..._buildDetailCards(data),

                  SizedBox(height: 20),

                  // 수정 버튼
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.color4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
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
                              backgroundColor: AppColors.color4,
                            ),
                          );
                        }).catchError((e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('저장에 실패했습니다.'),
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
                        '수정하기',
                        style: AppTypography.buttonLabelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(color: AppColors.color4),
          ),
          error: (e, st) => Center(
            child: Container(
              padding: EdgeInsets.all(32),
              margin: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.color3),
                  SizedBox(height: 16),
                  Text('오류 발생: $e', style: AppTypography.body1.copyWith(color: AppColors.color3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetailCards(Map<String, dynamic> data) {
    final cardData = [
      {'key': 'meetingDate', 'title': '만남 일정', 'desc': '매주 만나는 요일과 시간', 'when': '시작 시 작성'},
      {'key': 'followerExpectation', 'title': '따르미에 대한 기대', 'desc': '풍삶초를 시작하며 따르미가 어떤 기대나 소망을 가지고 시작하는지', 'when': '시작 시 작성'},
      {'key': 'myExpectation', 'title': '이끄미로서의 기대', 'desc': '풍삶초를 시작하며 이끄미로써 어떤 기대나 소망을 가지고 시작하는지', 'when': '시작 시 작성'},
      {'key': 'followerPray', 'title': '따르미 기도제목', 'desc': '따르미의 기도제목', 'when': '시작 시 작성'},
      {'key': 'myPray', 'title': '이끄미 기도제목', 'desc': '이끄미의 기도제목', 'when': '시작 시 작성'},
      {'key': 'followerChange', 'title': '따르미의 변화 과정', 'desc': '풍삶초를 통한 따르미의 변화된 점, 새롭게 알게 된 내용이나 중요하게 생각하게 된 부분, 결심하게 된 부분', 'when': '4~5주차 작성'},
      {'key': 'myChange', 'title': '이끄미의 변화 과정', 'desc': '중요하게 생각하게 된 내용, 따르미의 대화를 통하여 도전받은 부분, 결심하게 된 부분', 'when': '4~5주차 작성'},
      {'key': 'feedback', 'title': '풍삶초를 돌아보며', 'desc': '1) 따르미의 성장 관찰\n2) 이끄미로서 배우고 느낀 점\n3) 풍삶초를 마무리하며 나누고 싶은 점', 'when': '종료 시 작성 (가장 중요)'},
    ];

    return cardData.map((item) => Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
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
      child: _editableField(
        context,
        ref,
        item['key'] as String,
        item['title'] as String,
        item['desc'] as String,
        item['when'] as String,
        data[item['key']] as String,
      ),
    )).toList();
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
                    SnackBar(
                      content: Text('신고가 접수되었습니다.'),
                      backgroundColor: AppColors.color4,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('신고에 실패했습니다.'),
                      backgroundColor: AppColors.red,
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
                    SnackBar(
                      content: Text('삭제가 완료되었습니다.'),
                      backgroundColor: AppColors.color4,
                    ),
                  );
                  Navigator.pop(context);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('삭제에 실패했습니다.'),
                      backgroundColor: AppColors.red,
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
        Text(
          label,
          style: AppTypography.body2.copyWith(
            color: AppColors.color3,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.color5,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: AppTypography.body1.copyWith(
              color: AppColors.color2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
          controller: controller,
          minLines: 3,
          maxLines: 5,
          scrollPhysics: BouncingScrollPhysics(),
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
        Text(
          widget.label,
          style: AppTypography.body2.copyWith(
            color: AppColors.color3,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
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
                        child: Text(
                          '완료',
                          style: TextStyle(color: AppColors.color2),
                        ),
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
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.color5,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              displayText,
              style: AppTypography.body1.copyWith(color: AppColors.color2),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
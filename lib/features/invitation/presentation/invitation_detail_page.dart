import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_border_radius.dart';
import 'package:theone/features/invitation/provider/invitation_provider.dart';

class InvitationDetailPage extends ConsumerWidget {
  final String invitationId;

  const InvitationDetailPage({super.key, required this.invitationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationList = ref.watch(invitationListProvider);
    final editData = ref.watch(invitationEditDataProvider);

    final int parsedId = int.tryParse(invitationId) ?? -1;

    final invitation = invitationList.whenOrNull(
      data: (res) => res.firstWhere(
            (inv) => inv['invitationId'] == parsedId,
        orElse: () => {},
      ),
    );

    if (invitation == null) {
      return Scaffold(
        appBar: AppBar(title: Text('풍삶초 상세 정보', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)), centerTitle: true),
        body: Center(child: Text('풍삶초 정보를 찾을 수 없습니다.')),
      );
    }

    // 초기 상태 세팅
    ref.listenManual(invitationEditDataProvider, (previous, next) {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invitationEditDataProvider.notifier).state = {
        'invitationId': invitation['invitationId'],
        'followerName': invitation['followerName'],
        'oneWeekL': invitation['oneWeekL'],
        'oneWeekF': invitation['oneWeekF'],
        'oneWeekDate': invitation['oneWeekDate'],
        'twoWeekL': invitation['twoWeekL'],
        'twoWeekF': invitation['twoWeekF'],
        'twoWeekDate': invitation['twoWeekDate'],
        'threeWeekL': invitation['threeWeekL'],
        'threeWeekF': invitation['threeWeekF'],
        'threeWeekDate': invitation['threeWeekDate'],
        'fourWeekL': invitation['fourWeekL'],
        'fourWeekF': invitation['fourWeekF'],
        'fourWeekDate': invitation['fourWeekDate'],
        'fiveWeekL': invitation['fiveWeekL'],
        'fiveWeekF': invitation['fiveWeekF'],
        'fiveWeekDate': invitation['fiveWeekDate'],
        'sixWeekL': invitation['sixWeekL'],
        'sixWeekF': invitation['sixWeekF'],
        'sixWeekDate': invitation['sixWeekDate'],
        'startDate': invitation['startDate'],
        'endDate': invitation['endDate'],
        'progress': invitation['progress'], // 0, 1, 2 중 하나
      };
    });

    return Scaffold(
      appBar: AppBar(title: Text('풍삶초 상세 정보', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _dropdownProgress(ref),
            _dateField(ref, 'startDate', '시작일자'),
            _dateField(ref, 'endDate', '종료일자'),

            for (int i = 1; i <= 6; i++)
              _weekSection(ref, i),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final data = ref.read(invitationEditDataProvider);

                const progressToInt = {'진행중': 0, '종료': 1, '중단': 2};

                final formatted = {
                  ...data,
                  'progress': progressToInt[data['progress']] ?? 0, // 문자열을 숫자로 변환

                  'startDate': _formatDate(data['startDate']),
                  'endDate': _formatDate(data['endDate']),
                  for (int i = 1; i <= 6;)
                    '${_numToWord(i)}WeekDate': _formatDate(data['${_numToWord(i)}WeekDate']),
                };

                await ref.read(invitationRepositoryProvider).editInvitation(parsedId, formatted);
                ref.refresh(invitationListProvider);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('저장되었습니다')));
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdownProgress(WidgetRef ref) {
    const progressMap = {'진행중': 0, '종료': 1, '중단': 2};
    const reverseProgressMap = {0: '진행중', 1: '종료', 2: '중단'};

    final rawValue = ref.watch(invitationEditDataProvider)['progress'] ?? '진행중';
    final intValue = progressMap[rawValue] ?? 0;

    return DropdownButtonFormField<int>(
      value: intValue,
      decoration: InputDecoration(labelText: '진행상황'),
      items: progressMap.entries
          .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
          .toList(),
      onChanged: (val) {
        ref.read(invitationEditDataProvider.notifier).update(
              (state) => {...state, 'progress': reverseProgressMap[val!]},
        );
      },
    );
  }


  Widget _dateField(WidgetRef ref, String key, String label) {
    final dateStr = ref.watch(invitationEditDataProvider)[key] ?? '';
    final controller = TextEditingController(text: dateStr);

    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      onTap: () async {
        FocusScope.of(ref.context).unfocus();
        final selected = await showDatePicker(
          context: ref.context,
          initialDate: DateTime.tryParse(dateStr) ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (selected != null) {
          ref.read(invitationEditDataProvider.notifier).update((state) => {...state, key: selected.toIso8601String().split('T')[0]});
        }
      },
    );
  }

  Widget _weekSection(WidgetRef ref, int week) {
    final word = _numToWord(week);
    final followerKey = '${word}WeekF';
    final leaderKey = '${word}WeekL';
    final dateKey = '${word}WeekDate';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('[$week주차]', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          decoration: InputDecoration(labelText: '이끄미'),
          controller: TextEditingController(text: ref.watch(invitationEditDataProvider)[leaderKey] ?? ''),
          onChanged: (val) {
            ref.read(invitationEditDataProvider.notifier).update((state) => {...state, leaderKey: val});
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: '따르미'),
          controller: TextEditingController(text: ref.watch(invitationEditDataProvider)[followerKey] ?? ''),
          onChanged: (val) {
            ref.read(invitationEditDataProvider.notifier).update((state) => {...state, followerKey: val});
          },
        ),
        _dateField(ref, dateKey, '날짜'),
        SizedBox(height: 16),
      ],
    );
  }

  String _numToWord(int num) {
    const map = {
      1: 'one',
      2: 'two',
      3: 'three',
      4: 'four',
      5: 'five',
      6: 'six',
    };
    return map[num] ?? '';
  }

  String _formatDate(String date) {
    if (date.contains('T')) {
      return date.split('T')[0];
    }
    return date;
  }
}


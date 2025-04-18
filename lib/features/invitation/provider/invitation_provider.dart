import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/api_client_provider.dart';
import 'package:theone/features/invitation/data/invitation_api.dart';
import 'package:theone/features/invitation/data/invitation_repository.dart';
import 'package:flutter/material.dart';

final invitationApiProvider = Provider((ref) => InvitationApi(ref.read(apiClientProvider)));
final invitationRepositoryProvider = Provider((ref) => InvitationRepository(ref.read(invitationApiProvider)));
final invitationStatusProvider = StateProvider<String>((ref) => '진행중');

final createInvitationProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
  final repo = ref.read(invitationRepositoryProvider);
  await repo.createInvitation(data);
});

class InvitationListNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final repository = ref.read(invitationRepositoryProvider);
    return await repository.showInvitationList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(invitationRepositoryProvider);
      return await repository.showInvitationList();
    });
  }
}

final invitationListProvider =
AsyncNotifierProvider<InvitationListNotifier, List<Map<String, dynamic>>>(
        () => InvitationListNotifier());


final invitationEditProvider = StateProvider<int?>((ref) => null);

final invitationEditDataProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final invitationEditControllerProvider =
StateNotifierProvider<InvitationEditController, Map<String, TextEditingController>>(
      (ref) => InvitationEditController(ref),
);

final invitationDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, int id) async {
  final repo = ref.read(invitationRepositoryProvider);
  return await repo.getInvitationDetail(id);
});

final sendInvitationUpdateProvider = FutureProvider.family<void, (Map<String, dynamic>, int)>((ref, tuple) async {
  final repo = ref.read(invitationRepositoryProvider);
  final data = tuple.$1;
  final id = tuple.$2;
  await repo.updateInvitation(id, data);
});

final deleteInvitationProvider = FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final repo = ref.read(invitationRepositoryProvider);
  await repo.deleteInvitation(id);
});

class InvitationEditController extends StateNotifier<Map<String, TextEditingController>> {
  final Ref ref;

  InvitationEditController(this.ref) : super({});

  void startEditing(String key, String initialValue) {
    state = {
      ...state,
      key: TextEditingController(text: initialValue),
    };
    ref.read(invitationEditProvider.notifier).state = int.tryParse(key); // 혹은 따로 처리
  }

  void stopEditing() {
    state = {};
    ref.read(invitationEditProvider.notifier).state = null;
  }

  void updateEditDataField(String key, String value) {
    final prev = ref.read(invitationEditDataProvider);
    ref.read(invitationEditDataProvider.notifier).state = {
      ...prev,
      key: value,
    };
  }

  void initializeEditData(Map<String, dynamic> invitation) {
    ref.read(invitationEditDataProvider.notifier).state = Map.from(invitation);
  }
}





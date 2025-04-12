import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/api_client_provider.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';
import 'package:theone/features/invitation/data/invitation_api.dart';
import 'package:theone/features/invitation/data/invitation_repository.dart';
import 'package:flutter/material.dart';

final invitationApiProvider = Provider((ref) => InvitationApi(ref.read(apiClientProvider)));
final invitationRepositoryProvider = Provider((ref) => InvitationRepository(ref.read(invitationApiProvider)));
final invitationStatusProvider = StateProvider<String>((ref) => '진행중');

final invitationListProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.read(invitationRepositoryProvider);

  final authState = ref.watch(authProvider);

  return await repository.showInvitationList();
});

final invitationEditProvider = StateProvider<int?>((ref) => null);

final invitationEditDataProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final invitationEditControllerProvider =
StateNotifierProvider<InvitationEditController, Map<int, TextEditingController?>>((ref) {
  return InvitationEditController(ref);
});

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

final deleteInvitationProvider = Provider.family<void, int>((ref, id) {
  final repo = ref.read(invitationRepositoryProvider);
  repo.deleteInvitation(id);
});

class InvitationEditController extends StateNotifier<Map<int, TextEditingController?>> {
  final Ref ref;

  InvitationEditController(this.ref) : super({});

  void startEditing(int week, String initialValue) {
    state = {
      ...state,
      week: TextEditingController(text: initialValue),
    };
    ref.read(invitationEditProvider.notifier).state = week;
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



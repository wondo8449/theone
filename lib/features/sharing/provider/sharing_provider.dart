import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/api_client_provider.dart';
import 'package:theone/features/sharing/data/sharing_api.dart';
import 'package:theone/features/sharing/data/sharing_repository.dart';

final sharingApiProvider = Provider((ref) => SharingApi(ref.read(apiClientProvider)));
final sharingRepositoryProvider = Provider((ref) => SharingRepository(ref.read(sharingApiProvider)));

final sendSharingDataProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, Map<String, dynamic>>((ref, data) async {
  final repository = ref.read(sharingRepositoryProvider);
  return await repository.createSharing(data);
});

final modifySharingDataProvider = FutureProvider.family<void, (int, Map<String, dynamic>)>((ref, tuple) async {
  final repo = ref.read(sharingRepositoryProvider);
  final id = tuple.$1;
  final data = tuple.$2;
  await repo.modifySharing(id, data);
});

final sharingDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, id) async {
  final repository = ref.read(sharingRepositoryProvider);
  return await repository.getSharingDetail(id);
});


final deleteSharingProvider = FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final repository = ref.read(sharingRepositoryProvider);
  await repository.deleteSharing(id);
});

final declarationSharingProvider = FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final repository = ref.read(sharingRepositoryProvider);
  await repository.declarationSharing(id);
});

class QTSharingNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final repo = ref.read(sharingRepositoryProvider);
    return await repo.getQTSharingList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(sharingRepositoryProvider);
      return await repo.getQTSharingList();
    });
  }
}

final QTSharingProvider = AsyncNotifierProvider<QTSharingNotifier, List<Map<String, dynamic>>>(() => QTSharingNotifier());
final invitationSharingProvider = AsyncNotifierProvider<InvitationSharingNotifier, List<Map<String, dynamic>>>(() => InvitationSharingNotifier());

class InvitationSharingNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final repo = ref.read(sharingRepositoryProvider);
    return await repo.getInvitationSharingList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(sharingRepositoryProvider);
      return await repo.getInvitationSharingList();
    });
  }
}

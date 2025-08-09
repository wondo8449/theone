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

// 페이지와 검색어 상태 관리
final qtCurrentPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final invitationCurrentPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final qtSearchValueProvider = StateProvider.autoDispose<String?>((ref) => null);
final invitationSearchValueProvider = StateProvider.autoDispose<String?>((ref) => null);

class QTSharingNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final repo = ref.read(sharingRepositoryProvider);
    final page = ref.watch(qtCurrentPageProvider);
    final searchValue = ref.watch(qtSearchValueProvider);
    return await repo.getQTSharingList(page: page, searchValue: searchValue);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(sharingRepositoryProvider);
      final page = ref.read(qtCurrentPageProvider);
      final searchValue = ref.read(qtSearchValueProvider);
      return await repo.getQTSharingList(page: page, searchValue: searchValue);
    });
  }

  Future<void> loadNextPage() async {
    final currentPage = ref.read(qtCurrentPageProvider);
    ref.read(qtCurrentPageProvider.notifier).state = currentPage + 1;
  }

  Future<void> search(String? searchValue) async {
    ref.read(qtSearchValueProvider.notifier).state = searchValue;
    ref.read(qtCurrentPageProvider.notifier).state = 1; // 검색 시 페이지를 1로 초기화
  }
}

class InvitationSharingNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final repo = ref.read(sharingRepositoryProvider);
    final page = ref.watch(invitationCurrentPageProvider);
    final searchValue = ref.watch(invitationSearchValueProvider);
    return await repo.getInvitationSharingList(page: page, searchValue: searchValue);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(sharingRepositoryProvider);
      final page = ref.read(invitationCurrentPageProvider);
      final searchValue = ref.read(invitationSearchValueProvider);
      return await repo.getInvitationSharingList(page: page, searchValue: searchValue);
    });
  }

  Future<void> loadNextPage() async {
    final currentPage = ref.read(invitationCurrentPageProvider);
    ref.read(invitationCurrentPageProvider.notifier).state = currentPage + 1;
  }

  Future<void> search(String? searchValue) async {
    ref.read(invitationSearchValueProvider.notifier).state = searchValue;
    ref.read(invitationCurrentPageProvider.notifier).state = 1; // 검색 시 페이지를 1로 초기화
  }
}

final QTSharingProvider = AsyncNotifierProvider<QTSharingNotifier, List<Map<String, dynamic>>>(() => QTSharingNotifier());
final invitationSharingProvider = AsyncNotifierProvider<InvitationSharingNotifier, List<Map<String, dynamic>>>(() => InvitationSharingNotifier());
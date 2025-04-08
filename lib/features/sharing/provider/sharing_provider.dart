import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/api_client_provider.dart';
import 'package:theone/features/sharing/data/sharing_api.dart';
import 'package:theone/features/sharing/data/sharing_repository.dart';

final sharingApiProvider = Provider((ref) => SharingApi(ref.read(apiClientProvider)));
final sharingRepositoryProvider = Provider((ref) => SharingRepository(ref.read(sharingApiProvider)));

final QTSharingProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.read(sharingRepositoryProvider);

  return await repository.getQTSharingList();
});

final invitationSharingProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.read(sharingRepositoryProvider);

  return await repository.getInvitationSharingList();
});

final titleControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

final contentControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

final sendSharingDataProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, Map<String, dynamic>>((ref, data) async {
  final repository = ref.read(sharingRepositoryProvider);
  return await repository.createSharing(data);
});

final sharingDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, id) async {
  final repository = ref.read(sharingRepositoryProvider);
  return await repository.getSharingDetail(id);
});
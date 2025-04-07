import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/features/tree/data/tree_repository.dart';
import 'package:theone/core/api_client_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../data/tree_api.dart';

final treeApiProvider = Provider((ref) => TreeApi(ref.read(apiClientProvider)));
final treeRepositoryProvider = Provider((ref) => TreeRepository(ref.read(treeApiProvider)));

final yearMonthProvider = StateProvider<String>((ref) => '202504');
final searchValueProvider = StateProvider<String>((ref) => '고요나무');

final treeCommentsProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.read(treeRepositoryProvider);
  final yearMonth = ref.watch(yearMonthProvider);
  final searchValue = ref.watch(searchValueProvider);

  final authState = ref.watch(authProvider);
  final role = authState['role'];

  if (role == "ADMIN") {
    return await repository.getAdminComments(yearMonth, searchValue);
  } else {
    return await repository.getTreeComments(yearMonth);
  }
});

final commentEditProvider = StateProvider<Map<int, String>>((ref) => {});

final commentEditControllerProvider = StateProvider.family<TextEditingController, int>((ref, commentId) {
  return TextEditingController();
});

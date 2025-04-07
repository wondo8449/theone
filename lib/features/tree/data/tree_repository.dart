import 'package:theone/features/tree/data/tree_api.dart';

class TreeRepository {
  final TreeApi treeApi;

  TreeRepository(this.treeApi);

  Future<List<Map<String, dynamic>>> getTreeComments(String yearMonth) {
    return treeApi.fetchTreeComments(yearMonth);
  }

  Future<List<Map<String, dynamic>>> getAdminComments(String yearMonth, String searchValue) {
    return treeApi.fetchAdminComments(yearMonth, searchValue);
  }

  Future<void> editComment(int commentId, String newComment) {
    return treeApi.updateComment(commentId, newComment);
  }
}

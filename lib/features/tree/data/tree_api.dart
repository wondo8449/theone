import 'dart:convert';
import 'package:theone/core/api_client.dart';

class TreeApi {
  final ApiClient apiClient;

  TreeApi(this.apiClient);

  // 코멘트 목록 조회
  Future<List<Map<String, dynamic>>> fetchTreeComments(String yearMonth) async {
    final responseRaw = await apiClient.request('GET', '/comment/user/$yearMonth', null);
    final decodedResponse = jsonDecode(utf8.decode(responseRaw.bodyBytes));

    if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
      return List<Map<String, dynamic>>.from(
        (decodedResponse['data'] as List).map((item) => {
          'commentId': item['commentId'],
          'userId': item['userId'],
          'userName': item['userName'],
          'tree': item['tree'],
          'comment': item['comment'] ?? '',
        }),
      );
    } else {
      throw Exception(decodedResponse);
    }
  }

  Future<List<Map<String, dynamic>>> fetchAdminComments(String yearMonth, String searchValue) async {
    final responseRaw = await apiClient.request('GET', '/comment/user/$yearMonth?searchValue=$searchValue', null);
    final decodedResponse = jsonDecode(utf8.decode(responseRaw.bodyBytes));

    if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
      return List<Map<String, dynamic>>.from(
        (decodedResponse['data'] as List).map((item) => {
          'commentId': item['commentId'],
          'userId': item['userId'],
          'userName': item['userName'],
          'tree': item['tree'],
          'comment': item['comment'] ?? '',
        }),
      );
    } else {
      throw Exception(decodedResponse);
    }
  }

  // 코멘트 수정
  Future<void> updateComment(int commentId, String newComment) async {
    await apiClient.request('PATCH', '/comment/user', {
      'commentId': commentId,
      'comment': newComment,
    });
  }
}

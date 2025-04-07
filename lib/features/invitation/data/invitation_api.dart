import 'dart:convert';

import '../../../core/api_client.dart';

class InvitationApi {
  final ApiClient apiClient;
  InvitationApi(this.apiClient);

  Future<List<Map<String, dynamic>>> showInvitationList() async {
    final res = await apiClient.request('GET', '/invitation', null);
    final decodeRes = jsonDecode(utf8.decode(res.bodyBytes));

    if (decodeRes is Map<String, dynamic> && decodeRes.containsKey('data')) {
      return List<Map<String, dynamic>>.from(
          (decodeRes['data'] as List).map((res) => {
              'invitationId': res['invitationId'],
              'userId': res['userId'],
              'userName': res['userName'],
              'followerName': res['followerName'],
              'oneWeekL': res['oneWeekL'] ?? '',
              'oneWeekF': res['oneWeekF'] ?? '',
              'oneWeekDate': res['oneWeekDate'] ?? '',
              'twoWeekL': res['twoWeekL'] ?? '',
              'twoWeekF': res['twoWeekF'] ?? '',
              'twoWeekDate': res['twoWeekDate'] ?? '',
              'threeWeekL': res['threeWeekL'] ?? '',
              'threeWeekF': res['threeWeekF'] ?? '',
              'threeWeekDate': res['threeWeekDate'] ?? '',
              'fourWeekL': res['fourWeekL'] ?? '',
              'fourWeekF': res['fourWeekF'] ?? '',
              'fourWeekDate': res['fourWeekDate'] ?? '',
              'fiveWeekL': res['fiveWeekL'] ?? '',
              'fiveWeekF': res['fiveWeekF'] ?? '',
              'fiveWeekDate': res['fiveWeekDate'] ?? '',
              'sixWeekL': res['sixWeekL'] ?? '',
              'sixWeekF': res['sixWeekF'] ?? '',
              'sixWeekDate': res['sixWeekDate'] ?? '',
              'startDate': res['startDate'],
              'endDate': res['endDate'],
              'progress': res['progress'],
              'createdAt': res['createdAt'] ?? '',
              'modifiedAt': res['modifiedAt'] ?? ''
          })
      );
    } else {
      throw Exception(decodeRes);
    }
  }

  Future<List<Map<String, dynamic>>> editInvitation(int invitationId, Map<String, dynamic> dto) async {
    final res = await apiClient.request('PATCH', '/invitation/', dto);
    final decodeRes = jsonDecode(utf8.decode(res.bodyBytes));

    if (decodeRes is Map<String, dynamic> && decodeRes.containsKey('data')) {
      return List<Map<String, dynamic>>.from(
          (decodeRes['data'] as List).map((res) => {
            'invitationId': res['invitationId'],
          })
      );
    } else {
      throw Exception(decodeRes);
    }
  }
}
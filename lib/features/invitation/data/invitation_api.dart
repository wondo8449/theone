import 'dart:convert';

import '../../../core/api_client.dart';

class InvitationApi {
  final ApiClient apiClient;
  InvitationApi(this.apiClient);

  Future<Map<String, dynamic>> createInvitation(Map<String, dynamic> dto) async {
    try {
      final res = await apiClient.request('POST', '/invitation', dto);
      final decodeRes = jsonDecode(utf8.decode(res.bodyBytes));
      final data = decodeRes['data'];
      return {
        'invitationId': data['invitationId'],
        'userId': data['userId'],
        'userName': data['userName'],
        'followerName': data['followerName'],
        'startDate': data['startDate'],
        'endDate': data['endDate'] ?? '',
        'progress': data['progress'],
        'createdAt': data['createdAt'],
        'modifiedAt': data['modifiedAt']
      };
    } catch(e) {
      throw Exception(e);
    }
  }

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

  Future<Map<String, dynamic>> getInvitationDetail(int invitationId) async {
    try {
      final res = await apiClient.request('GET', '/invitation/$invitationId', null);
      final decodeRes = jsonDecode(utf8.decode(res.bodyBytes));
      final data = decodeRes['data'];
      return {
        'invitationId': data['invitationId'],
        'userId': data['userId'],
        'userName': data['userName'],
        'followerName': data['followerName'],
        'startDate': data['startDate'],
        'endDate': data['endDate'] ?? '',
        'meetingDate': data['meetingDate'] ?? '',
        'followerExpectation': data['followerExpectation'] ?? '',
        'myExpectation': data['myExpectation'] ?? '',
        'followerChange': data['followerChange'] ?? '',
        'myChange': data['myChange'] ?? '',
        'followerPray': data['followerPray'] ?? '',
        'myPray': data['myPray'] ?? '',
        'feedback': data['feedback'] ?? '',
        'progress': data['progress'],
        'createdAt': data['createdAt'],
        'modifiedAt': data['modifiedAt']
      };
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> editInvitation(int invitationId, Map<String, dynamic> dto) async {
    try {
      final res = await apiClient.request('PATCH', '/invitation/$invitationId', dto);
      final decodeRes = jsonDecode(utf8.decode(res.bodyBytes));
      final data = decodeRes['data'];
      return {
        'invitationId': data['invitationId'],
        'userId': data['userId'],
        'userName': data['userName'],
        'followerName': data['followerName'],
        'startDate': data['startDate'],
        'endDate': data['endDate'] ?? '',
        'progress': data['progress'],
        'createdAt': data['createdAt'],
        'modifiedAt': data['modifiedAt']
      };
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<void> deleteInvitation(int invitationId) async {
    try {
      final res = await apiClient.request('DELETE', '/invitation/$invitationId', null);
      final decodeRes = jsonDecode(utf8.decode(res.bodyBytes));
    } catch(e) {
      throw Exception(e);
    }
  }

}
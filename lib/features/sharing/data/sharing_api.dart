import 'dart:convert';
import 'package:theone/core/api_client.dart';

class SharingApi {
  final ApiClient apiClient;

  SharingApi(this.apiClient);

  Future<List<Map<String, dynamic>>> getQTSharingList({int page = 1, String? searchValue}) async {
    String url = '/sharing/0?page=$page';
    if (searchValue != null && searchValue.isNotEmpty) {
      url += '&searchValue=${Uri.encodeComponent(searchValue)}';
    }

    final responseRaw = await apiClient.request('GET', url, null);
    final decodedResponse = jsonDecode(utf8.decode(responseRaw.bodyBytes));

    if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
      return List<Map<String, dynamic>>.from(
        (decodedResponse['data'] as List).map((item) => {
          'sharingId': item['sharingId'],
          'userName': item['userName'],
          'title': item['title'] ?? '',
          'content': item['content'] ?? '',
          'createdAt': item['createdAt'],
          'modifiedAt': item['modifiedAt'] ?? ''
        }),
      );
    } else {
      throw Exception(decodedResponse);
    }
  }

  Future<List<Map<String, dynamic>>> getInvitationSharingList({int page = 1, String? searchValue}) async {
    String url = '/sharing/1?page=$page';
    if (searchValue != null && searchValue.isNotEmpty) {
      url += '&searchValue=${Uri.encodeComponent(searchValue)}';
    }

    final responseRaw = await apiClient.request('GET', url, null);
    final decodedResponse = jsonDecode(utf8.decode(responseRaw.bodyBytes));

    if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
      return List<Map<String, dynamic>>.from(
        (decodedResponse['data'] as List).map((item) => {
          'sharingId': item['sharingId'],
          'userName': item['userName'],
          'title': item['title'] ?? '',
          'content': item['content'] ?? '',
          'createdAt': item['createdAt'],
        }),
      );
    } else {
      throw Exception(decodedResponse);
    }
  }

  Future<Map<String, dynamic>> createSharing(Map<String, dynamic> data) async {
    final responseRaw = await apiClient.request('POST', '/sharing', {
      'title': data.values.elementAt(0), 'content': data.values.elementAt(1), 'sectionCode': data.values.elementAt(2)}
    );
    final decodedResponse = jsonDecode(utf8.decode(responseRaw.bodyBytes));

    if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
      final data = decodedResponse['data'];
      return {
        'sharingId': data['sharingId'],
        'userName': data['userName'],
        'title': data['title'] ?? '',
        'content': data['content'] ?? '',
        'createdAt': data['createdAt'],
      };
    } else {
      throw Exception(decodedResponse);
    }
  }

  Future<Map<String, dynamic>> getSharingDetail(int id) async {
    try {
      final responseRaw = await apiClient.request('GET', '/sharing/detail/$id', null);
      final decodedResponse = jsonDecode(utf8.decode(responseRaw.bodyBytes));

      if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
        final data = decodedResponse['data'];
        return {
          'sharingId': data['sharingId'],
          'userName': data['userName'],
          'title': data['title'] ?? '',
          'content': data['content'] ?? '',
          'createdAt': data['createdAt'],
        };
      } else {
        throw Exception('Invalid response format: $decodedResponse');
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> modifySharing(int id, Map<String, dynamic> data) async {
    try{
      final responseRaw = await apiClient.request('PATCH', '/sharing/$id', data);
      final decodedResponse = jsonDecode(utf8.decode(responseRaw.bodyBytes));

      if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
        final data = decodedResponse['data'];
        return {
          'sharingId': data['sharingId'],
          'userName': data['userName'],
          'title': data['title'] ?? '',
          'content': data['content'] ?? '',
          'createdAt': data['createdAt'],
        };
      } else {
        throw Exception('Invalid response format: $decodedResponse');
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<void> deleteSharing(int id) async {
    try{
      final responseRaw = await apiClient.request('DELETE', '/sharing/$id', null);
      final decodedResponse = jsonDecode(utf8.decode(responseRaw.bodyBytes));
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<void> declarationSharing(int id) async {
    try{
      final responseRaw = await apiClient.request('GET', '/declaration/$id', null);
      final decodedResponse = jsonDecode(utf8.decode(responseRaw.bodyBytes));
    } catch(e) {
      throw Exception(e);
    }
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final String baseUrl = 'http://14.5.86.192/api';
  final storage = const FlutterSecureStorage();

  // 저장된 JWT 토큰 가져오기
  Future<String?> getToken() async {
    return await storage.read(key: 'accessToken');
  }

  // HTTP 요청 메서드
  Future<http.Response> request(String method, String endpoint, Map<String, dynamic>? body) async {
    final url = Uri.parse('${baseUrl}$endpoint');
    final token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    http.Response response;
    switch (method) {
      case 'POST':
        response = await http.post(url, headers: headers, body: jsonEncode(body));
        break;
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'PATCH':
        response = await http.patch(url, headers: headers, body: jsonEncode(body));
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers, body: jsonEncode(body));
        break;
      default:
        throw Exception('Unsupported HTTP method');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('API 요청 실패: ${response.body}');
    }
  }


  Future<http.Response> rawPost(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('API 요청 실패: ${response.body}');
    }
  }

}

import 'dart:convert';
import 'dart:io' show HttpException;
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  static String get baseUrl => AppConfig.apiBaseUrl;

  // 单例模式
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    String? baseUrl,
  }) async {
    try {
      final effectiveBaseUrl = baseUrl ?? ApiService.baseUrl;
      final uri = Uri.parse('$effectiveBaseUrl$path').replace(
        queryParameters: queryParameters,
      );

      print('发送 POST 请求: $uri');
      print('请求体: $body');

      final response = await http
          .post(
            uri,
            headers: await _getHeaders(),
            body: jsonEncode(body ?? {}),
          )
          .timeout(const Duration(seconds: 5));

      print('响应状态: ${response.statusCode}');
      print('响应数据: ${response.body}');

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _validateResponse(response.statusCode, json);

      return json;
    } catch (e) {
      print('POST 请求错误: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    String? baseUrl,
  }) async {
    try {
      final effectiveBaseUrl = baseUrl ?? ApiService.baseUrl;
      final uri = Uri.parse('$effectiveBaseUrl$path').replace(
        queryParameters: queryParameters,
      );

      print('发送 PUT 请求: $uri');
      print('请求体: $body');

      final response = await http
          .put(
            uri,
            headers: await _getHeaders(),
            body: jsonEncode(body ?? {}),
          )
          .timeout(const Duration(seconds: 5));

      print('响应状态: ${response.statusCode}');
      print('响应数据: ${response.body}');

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _validateResponse(response.statusCode, json);

      return json;
    } catch (e) {
      print('PUT 请求错误: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
    String? baseUrl,
  }) async {
    try {
      final effectiveBaseUrl = baseUrl ?? ApiService.baseUrl;
      final uri = Uri.parse('$effectiveBaseUrl$path').replace(
        queryParameters: queryParameters,
      );

      print('发送 GET 请求: $uri');

      final response = await http
          .get(
            uri,
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: 5));

      print('响应状态: ${response.statusCode}');
      print('响应数据: ${response.body}');

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _validateResponse(response.statusCode, json);

      return json;
    } catch (e) {
      print('GET 请求错误: $e');
      rethrow;
    }
  }

  void _validateResponse(int statusCode, Map<String, dynamic> json) {
    if (statusCode >= 400) {
      throw HttpException(json['message'] ?? '请求失败');
    }
  }
}

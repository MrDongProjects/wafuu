import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/user_update_dto.dart';
import '../models/user_settings.dart';
import 'api_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  late SharedPreferences _prefs;
  User? _currentUser;
  final ApiService _apiService = ApiService();
  bool _initialized = false;

  // 单例模式
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    await _restoreSession();
    _initialized = true;
  }

  Future<(bool, String)> login(String username, String password) async {
    try {
      print('开始登录请求...');
      final response = await _apiService.post(
        '/api/users/login',
        body: {
          'username': username,
          'password': password,
        },
      );

      print('登录响应数据: $response');

      if (response['code'] == 200 && response['data'] != null) {
        final userData = response['data'] as Map<String, dynamic>;
        await _saveUserData(userData);
        return (true, response['msg'] as String? ?? '登录成功');
      } else {
        return (false, response['msg'] as String? ?? '登录失败');
      }
    } catch (e) {
      print('登录错误: $e');
      return (false, '登录失败：网络错误或服务器异常');
    }
  }

  Future<(bool, String)> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/users/register',
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return (
        response['code'] == 200,
        response['message'] as String? ?? '注册失败'
      );
    } catch (e) {
      return (false, '注册失败：网络错误或服务器异常');
    }
  }

  Future<void> logout() async {
    print('执行登出操作...');
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
    _currentUser = null;
    print('登出完成，清除用户数据');
  }

  User? get currentUser => _currentUser;

  Future<bool> isLoggedIn() async {
    if (!_initialized) await init();
    final hasUser = _currentUser != null;
    print('检查登录状态: ${hasUser ? "已登录" : "未登录"}');
    return hasUser;
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      print('保存用户数据: $userData');
      await _prefs.setString(_userKey, jsonEncode(userData));
      _currentUser = User.fromMap(userData);
      print('用户数据保存成功: ${_currentUser?.username}');
    } catch (e) {
      print('保存用户数据失败: $e');
      rethrow;
    }
  }

  Future<void> _restoreSession() async {
    try {
      final userJson = _prefs.getString(_userKey);
      print('恢复会话，保存的用户数据: $userJson');
      if (userJson != null) {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        _currentUser = User.fromMap(userData);
        print('会话恢复成功，当前用户: ${_currentUser?.username}');
      }
    } catch (e) {
      print('恢复会话错误: $e');
    }
  }

  Future<(bool, String)> resetPassword(String email) async {
    try {
      final response = await _apiService.post(
        '/api/users/reset-password',
        body: {'email': email},
      );
      return (
        response['code'] == 200,
        response['message'] as String? ?? '重置密码失败'
      );
    } catch (e) {
      return (false, '重置密码失败：网络错误或服务器异常');
    }
  }

  Future<(bool, String)> updateUserInfo(UserUpdateDto updateDto) async {
    try {
      if (_currentUser?.id == null) {
        return (false, '用户未登录');
      }

      final response = await _apiService.put(
        '/api/users/${_currentUser!.id}',
        body: updateDto.toJson(),
      );

      if (response['code'] == 200 && response['data'] != null) {
        await _saveUserData(response['data'] as Map<String, dynamic>);
        return (true, '更新成功');
      } else {
        return (false, response['message'] as String? ?? '更新失败');
      }
    } catch (e) {
      return (false, '更新失败：网络错误或服务器异常');
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final response = await _apiService.get('/api/users/check-auth');
      return response['code'] == 200;
    } catch (e) {
      print('验证身份状态失败: $e');
      return false;
    }
  }

  Future<(bool, String)> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (_currentUser?.id == null) {
        return (false, '用户未登录');
      }

      final response = await _apiService.put(
        '/api/users/${_currentUser!.id}/password',
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response['code'] == 200) {
        if (response['data'] != null) {
          await _saveUserData(response['data'] as Map<String, dynamic>);
        }
        return (true, response['msg'] as String? ?? '密码修改成功');
      } else {
        return (false, response['msg'] as String? ?? '密码修改失败');
      }
    } catch (e) {
      print('修改密码错误: $e');
      return (false, '密码修改失败：网络错误或服务器异常');
    }
  }

  Future<UserSettings?> getUserSettings() async {
    try {
      if (_currentUser?.id == null) {
        throw Exception('用户未登录');
      }

      final response = await _apiService.get(
        '/api/users/${_currentUser!.id}/settings',
      );

      if (response['code'] == 200 && response['data'] != null) {
        return UserSettings.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        throw Exception(response['msg'] ?? '获取设置失败');
      }
    } catch (e) {
      print('获取用户设置错误: $e');
      rethrow;
    }
  }

  Future<UserSettings> updateUserSettings(UserSettings settings) async {
    try {
      if (_currentUser?.id == null) {
        throw Exception('用户未登录');
      }

      final response = await _apiService.put(
        '/api/users/${_currentUser!.id}/settings',
        body: settings.toJson(),
      );

      if (response['code'] == 200 && response['data'] != null) {
        return UserSettings.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        throw Exception(response['msg'] ?? '更新设置失败');
      }
    } catch (e) {
      print('更新用户设置错误: $e');
      rethrow;
    }
  }
}

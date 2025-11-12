import 'dart:developer';
import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';
import '../../model/user_model.dart';
import '../../services/dio_config.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio = DioConfig.dio;

  @override
  Future<UserModel?> login(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('${ApiConstants.baseUrl}/users/login', data: userData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = response.data;

        final userJson = (res is Map)
            ? Map<String, Object?>.from(res['data'] ?? res)
            : <String, Object?>{};

        return UserModel.fromJson(userJson);
      }

      log('Unexpected login response: ${response.statusCode} ${response.data}');
      return null;
    } on DioException catch (e, st) {
      log('Dio Login Error: ${e.message}', stackTrace: st);
      if (e.response != null) {
        log('Error Response: ${e.response?.data}');
        log('Status Code: ${e.response?.statusCode}');
      }
      return null;
    } catch (e, st) {
      log('Unexpected Login Error: $e', stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/users/logout');
    } catch (e) {
      log('Logout error: $e');
    }
  }
}

import 'dart:developer';
import 'package:dio/dio.dart';
import '../../config/get_it.dart';
import '../../constants/api_constants.dart';
import '../../model/user_model.dart';
import '../../services/dio_config.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LoggerService logger = getIt<LoggerService>();

  final Dio _dio = DioConfig.dio;

  @override
  Future<UserModel?> login(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/login',
        data: userData,
      );

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
  Future<UserModel?> register(Map<String, dynamic> data) async {
    try {
      logger.info('Sending data to create profile: $data');
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/auth/register',
        data: data,
      );

      logger.info('Response (${response.statusCode}): ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = response.data;
        final userJson = res is Map<String, dynamic>
            ? (res['data'] ?? res['user'] ?? res)
            : <String, dynamic>{};

        final userMap = userJson is Map<String, dynamic>
            ? {
                'uid': userJson['firebaseUid'] ?? userJson['uid'] ?? '',
                'name': userJson['name'] ?? '',
                'email': userJson['email'] ?? '',
                '_id': userJson['_id']?.toString() ?? '',
                'id': userJson['_id']?.toString() ?? '',
                'isVerified': false,
                'uniqueId': userJson['uniqueId']?.toString() ?? '0',
                'following': '0',
                'followers': '0',
                'friends': '0',
              }
            : <String, dynamic>{};

        return UserModel.fromMap(userMap);
      }
      logger.error('Server returned error: ${response.statusCode}');
      return null;
    } on DioException catch (dioError) {
      logger.error('Dio error: ${dioError.message}');
      return null;
    } catch (e) {
      logger.error('Unexpected error: $e');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      log('Logout error: $e');
    }
  }
}

import 'dart:io';
import 'package:dio/dio.dart';
import '../../config/get_it.dart';
import '../../constants/api_constants.dart';
import '../../model/user_model.dart';
import '../../services/dio_config.dart';
import '../profileRepository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final LoggerService logger = getIt<LoggerService>();
  final Dio _dio = DioConfig.dio;

  @override
  Future<UserModel?> createProfile(Map<String, dynamic> data) async {
    try {
      logger.info('Sending data to create profile: $data');
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/users/register',
        data: data,
      );

      logger.info('Response (${response.statusCode}): ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = response.data;
        final userJson = res is Map<String, dynamic>
            ? (res['data'] ?? res)
            : <String, dynamic>{};
        return UserModel.fromJson(userJson);

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
  Future<UserModel?> updateProfile(FormData data) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/users/updateUserProfile',
        data: data,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = response.data;
        final userJson = res is Map<String, dynamic>
            ? (res['data'] ?? res)
            : <String, dynamic>{};
        return UserModel.fromJson(userJson);
      }
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
  Future<UserModel?> getProfile(String id) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/users/getUserProfile/$id',
      );

      if (response.statusCode == 200) {
        final res = response.data;
        final userJson = res is Map<String, dynamic>
            ? (res['data'] ?? res)
            : <String, dynamic>{};
        return UserModel.fromJson(userJson);
      }
      logger.error('Failed to fetch profile: ${response.statusCode}');
      return null;
    } on DioException catch (dioError) {
      logger.error('Dio error while fetching profile: ${dioError.message}');
      return null;
    } catch (e) {
      logger.error('Unexpected error: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> getOtherUserProfile(String id) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/users/getOtherUserProfile/$id',
      );

      if (response.statusCode == 200) {
        final res = response.data;
        final userJson = res is Map<String, dynamic>
            ? (res['data'] ?? res)
            : <String, dynamic>{};
        return UserModel.fromJson(userJson);
      }
      logger.error('Failed to fetch profile: ${response.statusCode}');
      return null;
    } on DioException catch (dioError) {
      logger.error('Dio error while fetching profile: ${dioError.message}');
      return null;
    } catch (e) {
      logger.error('Unexpected error: $e');
      return null;
    }
  }

}

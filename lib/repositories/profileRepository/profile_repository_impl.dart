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
  Future<UserModel?> updateProfile(FormData data) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/profile/updateUserProfile',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = response.data;
        final userJson = res is Map<String, dynamic>
            ? (res['user'] ?? res['data'] ?? res)
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
  Future<UserModel?> updateProfileData(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/profile/updateUserProfile',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = response.data;
        final userJson = res is Map<String, dynamic>
            ? (res['user'] ?? res['data'] ?? res)
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
  Future<UserModel?> uploadProfileImage(String imageUrl) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/profile/upload/profile-image',
        data: {'imageUrl': imageUrl},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = response.data;
        // Backend returns { success: true, user: userProfile }
        final userJson = res is Map<String, dynamic>
            ? (res['user'] ?? res['data'] ?? res)
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
        '${ApiConstants.baseUrl}/profile/getUserProfile/$id',
      );

      if (response.statusCode == 200) {
        final res = response.data;
        final userJson = res is Map<String, dynamic>
            ? (res['user'] ?? res['data'] ?? res)
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
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/profile/getCurrentUser',
      );

      if (response.statusCode == 200) {
        final res = response.data;
        final userJson = res is Map<String, dynamic>
            ? (res['user'] ?? res['data'] ?? res)
            : <String, dynamic>{};
        return UserModel.fromJson(userJson);
      }
      logger.error('Failed to fetch current user: ${response.statusCode}');
      return null;
    } on DioException catch (dioError) {
      logger.error('Dio error while fetching current user: ${dioError.message}');
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
        '${ApiConstants.baseUrl}/profile/getOtherUserProfile/$id',
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
  Future<void> updateFcmToken(Map<String, dynamic> data) async {
    try {
      final response = await DioConfig.dio.post(
        "${ApiConstants.baseUrl}/profile/update-fcm-token",
        data: data,
      );

      if (response.statusCode == 200) {
        logger.info("FCM token updated successfully");
      } else {
        logger.info("Failed to update FCM token: ${response.data}");
      }
    } catch (e) {
      logger.error("Error updating FCM token: $e");
    }
  }
}

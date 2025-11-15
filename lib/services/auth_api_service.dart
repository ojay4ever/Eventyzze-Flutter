import 'dart:developer';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../services/dio_config.dart';

class AuthApiService {
  final Dio _dio = DioConfig.dio;

  /// Create account with email/password
  Future<Map<String, dynamic>?> createAccount({
    required String idToken,
    required String name,
    required String email,
    String? profilePicture,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/auth/create-account',
        data: {
          'idToken': idToken,
          'name': name,
          'email': email,
          if (profilePicture != null) 'profilePicture': profilePicture,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      log('Error creating account: ${e.message}');
      if (e.response != null) {
        log('Error Response: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      log('Unexpected error creating account: $e');
      rethrow;
    }
  }

  /// Sign in with Google
  Future<Map<String, dynamic>?> signInWithGoogle({
    required String idToken,
    required String email,
    String? name,
    String? profilePicture,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/auth/google',
        data: {
          'idToken': idToken,
          'email': email,
          if (name != null) 'name': name,
          if (profilePicture != null) 'profilePicture': profilePicture,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      log('Error signing in with Google: ${e.message}');
      if (e.response != null) {
        log('Error Response: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      log('Unexpected error signing in with Google: $e');
      rethrow;
    }
  }

  /// Sign in with Apple
  Future<Map<String, dynamic>?> signInWithApple({
    required String idToken,
    required String email,
    String? name,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/auth/apple',
        data: {
          'idToken': idToken,
          'email': email,
          if (name != null) 'name': name,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      log('Error signing in with Apple: ${e.message}');
      if (e.response != null) {
        log('Error Response: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      log('Unexpected error signing in with Apple: $e');
      rethrow;
    }
  }

  /// Verify token
  Future<Map<String, dynamic>?> verifyToken({required String idToken}) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/auth/verify-token',
        data: {'idToken': idToken},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      log('Error verifying token: ${e.message}');
      if (e.response != null) {
        log('Error Response: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      log('Unexpected error verifying token: $e');
      rethrow;
    }
  }
}

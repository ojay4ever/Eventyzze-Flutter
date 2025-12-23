import 'dart:io';

import 'package:dio/dio.dart';
import '../../model/user_model.dart';


abstract class ProfileRepository {
  Future<UserModel?> updateProfile(FormData data);
  Future<UserModel?> updateProfileData(Map<String, dynamic> data);
  Future<UserModel?> uploadProfileImage(String imageUrl);
  Future<UserModel?> getProfile(String dbId);
  Future<UserModel?> getCurrentUser();
  Future<UserModel?> getOtherUserProfile(String dbId);
  Future<void> updateFcmToken(Map<String, dynamic> data);

}

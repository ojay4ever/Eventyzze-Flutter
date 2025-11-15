import 'dart:io';

import 'package:dio/dio.dart';
import '../../model/user_model.dart';


abstract class ProfileRepository {
  Future<UserModel?> updateProfile(FormData data);
  Future<UserModel?> getProfile(String dbId);
  Future<UserModel?> getOtherUserProfile(String dbId);
  Future<void> updateFcmToken(Map<String, dynamic> data);

}

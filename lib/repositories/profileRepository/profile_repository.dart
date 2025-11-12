import 'dart:io';

import 'package:dio/dio.dart';
import '../../model/user_model.dart';


abstract class ProfileRepository {
  Future<UserModel?> createProfile(Map<String, dynamic> data);
  Future<UserModel?> updateProfile(FormData data);
  Future<UserModel?> getProfile(String dbId);
  Future<UserModel?> getOtherUserProfile(String dbId);


}

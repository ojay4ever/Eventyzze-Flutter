import '../../model/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel?> login(Map<String, dynamic> userData);
  Future<void> logout();
}

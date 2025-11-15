import '../../model/user_model.dart';


abstract class AuthRepository {
  Future<UserModel?> register(Map<String, dynamic> data);
  Future<UserModel?> login(Map<String, dynamic> userData);
  Future<void> logout();
}

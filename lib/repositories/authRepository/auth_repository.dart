import '../../model/user_model.dart';


abstract class AuthRepository {
  Future<UserModel?> login(Map<String, dynamic> userData);
  Future<void> logout();
}

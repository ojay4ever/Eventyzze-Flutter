import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cache/shared_preferences_helper.dart';
import '../repositories/authRepository/auth_repository.dart';
import '../repositories/authRepository/auth_repository_impl.dart';


final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<SharedPrefsHelper>(
        () => SharedPrefsHelper(sharedPreferences: prefs),
  );

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());


}

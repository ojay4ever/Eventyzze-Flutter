import 'package:bloc/bloc.dart';
import 'package:eventyzze/repositories/authRepository/auth_repository.dart';
import 'package:eventyzze/repositories/authRepository/auth_repository_impl.dart';
import 'package:eventyzze/repositories/eventRepository/event_repository.dart';
import 'package:eventyzze/repositories/eventRepository/event_repository_impl.dart';
import 'package:eventyzze/repositories/profileRepository/profile_repository.dart';
import 'package:eventyzze/repositories/profileRepository/profile_repository_impl.dart';
import 'package:eventyzze/repositories/streamRepository/stream_repository.dart';
import 'package:eventyzze/repositories/streamRepository/stream_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../cache/shared_preferences_helper.dart';
import 'logger_services/talker_success_log.dart';

part 'logger_services/logger_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<LoggerService>(LoggerServiceDevelop());
  getIt.registerLazySingleton<SharedPrefsHelper>(
    () => SharedPrefsHelper(sharedPreferences: prefs),
  );
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<EventRepository>(() => EventRepositoryImpl());
  getIt.registerLazySingleton<StreamRepository>(() => StreamRepositoryImpl());
}

import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/customWidgets/home_tab.dart';
import 'package:eventyzze/services/dio_config.dart';
import 'package:eventyzze/views/authScreens/authController/auth_controller.dart';
import 'package:eventyzze/views/eventScreens/event_confirmation_screen.dart';
import 'package:eventyzze/views/pubscriptionPrompt%20/upgrade_prompt.dart';
import 'package:eventyzze/views/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'config/app_utils.dart';
import 'config/get_it.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'firebase_options.dart';

io.Socket? socket;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initDependencies();
  runApp(const MyApp());
}

Future<void> _initDependencies() async {
  await configureDependencies();
  Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  DioConfig.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventyzze',
      theme: AppTheme.theme,
      home: SplashScreen(),
    );
  }
}

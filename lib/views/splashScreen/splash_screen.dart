import 'dart:async';
import 'package:eventyzze/customWidgets/home_tab.dart';
import 'package:eventyzze/views/splashScreen/user_agreement.dart';
import 'package:eventyzze/views/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cache/shared_preferences_helper.dart';
import '../../config/app_images.dart';
import '../../config/get_it.dart';
import '../../helper/navigation_helper.dart';
import '../../repositories/profileRepository/profile_repository.dart';
import '../../services/socket_service.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ProfileRepository _profileRepo = getIt<ProfileRepository>();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _checkIfLoggedIn);
  }

  Future<void> _checkIfLoggedIn() async {

    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool('tosAccepted_v1') ?? false;

    if (!accepted) {
      final bool? acceptedNow = await Navigator.of(Get.context!).push<bool>(
        MaterialPageRoute(builder: (_) => const UserAgreementScreen()),
      );

      if (acceptedNow == true) {
        await prefs.setBool('tosAccepted_v1', true);
      } else {
        SystemNavigator.pop();
        return;
      }
    }

    final user = FirebaseAuth.instance.currentUser;
    final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper(
      sharedPreferences: prefs,
    );
    String dbId = await sharedPrefsHelper.getDatabaseId();
    if (user != null && dbId.isNotEmpty) {
      try {

        final profile = await _profileRepo.getProfile(dbId);
        if (profile != null) {

          await sharedPrefsHelper.setDatabaseId(profile.dbId);

          SocketService().connect(profile.dbId);
          if (!mounted) return;
          NavigationHelper.goToNavigatorScreen(
            Get.context!,
            HomeTab(),
            finish: true,
            back: false,
          );
        } else {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          NavigationHelper.goToNavigatorScreen(
            Get.context!,
            WelcomeScreen(),
            finish: true,
            back: false,
          );
        }
      } catch (e) {
        if (!mounted) return;
        NavigationHelper.goToNavigatorScreen(
          Get.context!,
          WelcomeScreen(),
          finish: false,
          back: false,
        );
      }
    } else {
      if (!mounted) return;
      NavigationHelper.goToNavigatorScreen(
        context,
        WelcomeScreen(),
        finish: true,
        back: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.airPhone),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

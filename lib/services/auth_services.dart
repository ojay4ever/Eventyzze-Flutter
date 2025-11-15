import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cache/pref_keys.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences? _prefs;

  User? get currentUser => _auth.currentUser;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await clearToken();
  }

  Future<String?> getBearerToken() async {
    await initialize();
    final User? user = currentUser;
    if (user == null) return null;
    final String? storedToken = _prefs!.getString("token");
    final String? tokenExpiryString = _prefs!.getString("tokenExpiry");
    print('debug token: $storedToken');
    if (storedToken == null || tokenExpiryString == null) {
      return _storeToken();
    }

    final DateTime now = DateTime.now();
    final DateTime tokenExpiryDate = DateTime.parse(tokenExpiryString);

    if (now.isAfter(tokenExpiryDate) ||
        now.isAtSameMomentAs(tokenExpiryDate) ||
        tokenExpiryDate.difference(now).inMinutes <= 10) {
      return _storeToken();
    }

    return storedToken;
  }

  Future<String?> _storeToken() async {
    try {
      await initialize();
      final User? user = currentUser;
      if (user == null) {
        log('No current user found, clearing token');
        await clearToken();
        return null;
      }

      log('Fetching fresh token for user: ${user.uid}');
      final IdTokenResult result = await user.getIdTokenResult(true);

      if (result.token != null) {
        await _prefs!.setString("token", result.token!);
        log('Token stored successfully');
      } else {
        log('Warning: getIdTokenResult returned null token');
      }

      if (result.expirationTime != null) {
        await _prefs!.setString(
          "tokenExpiry",
          result.expirationTime!.toIso8601String(),
        );
        log('Token expiry stored: ${result.expirationTime}');
      }

      return result.token;
    } catch (e) {
      log('Error storing token: $e');
      return null;
    }
  }

  Future<void> clearToken() async {
    await initialize();
    await _prefs!.remove("token");
    await _prefs!.remove("tokenExpiry");
    await _prefs!.remove(PrefKeys.userId);
  }
}

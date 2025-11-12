import 'dart:convert';
import 'package:eventyzze/cache/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  final SharedPreferences sharedPreferences;

  SharedPrefsHelper({required this.sharedPreferences});

  Map<String, dynamic> profileSetupMap = {};

  Future<void> setLastScreenName(String screenName) async {
    await sharedPreferences.setString(PrefKeys.lastScreenKey, screenName);
  }

  Future<String> getLastScreenName() async {
    return sharedPreferences.getString(PrefKeys.lastScreenKey) ?? '';
  }

  Future<void> setUserProfileSetupData(String key, Map dataMap) async {
    final String encodedMap = jsonEncode(dataMap);
    await sharedPreferences.setString(PrefKeys.profileSetupMapKey, encodedMap);
  }

  Future<Map<String, dynamic>?> getUserProfileSetupMap() async {
    final String? encodedMap = sharedPreferences.getString(
      PrefKeys.profileSetupMapKey,
    );
    if (encodedMap != null) {
      return jsonDecode(encodedMap) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<void> setUserLoggedIn(bool isLoggedIn) async {
    await sharedPreferences.setBool(PrefKeys.isLoggedIn, isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool(PrefKeys.isLoggedIn) ?? false;
  }

  Future<void> setUserId(String userId) async {
    await sharedPreferences.setString(PrefKeys.userId, userId);
  }

  Future<String> getUserId() async {
    return sharedPreferences.getString(PrefKeys.userId) ?? '';
  }

  Future<void> setToken(String token) async {
    await sharedPreferences.setString(PrefKeys.token, token);
  }

  Future<String> getToken() async {
    return sharedPreferences.getString(PrefKeys.token) ?? '';
  }

  Future<void> setTokenExpiry(String tokenExpiry) async {
    await sharedPreferences.setString(PrefKeys.tokenExpiry, tokenExpiry);
  }

  Future<String> getTokenExpiry() async {
    return sharedPreferences.getString(PrefKeys.tokenExpiry) ?? '';
  }

  Future<void> setUserName(String userId) async {
    await sharedPreferences.setString(PrefKeys.userName, userId);
  }

  Future<String> getUserName() async {
    return sharedPreferences.getString(PrefKeys.userName) ?? '';
  }

  Future<void> setUserLocation(String userId) async {
    await sharedPreferences.setString(PrefKeys.userLocation, userId);
  }

  Future<String> getUserLocation() async {
    return sharedPreferences.getString(PrefKeys.userLocation) ?? '';
  }

  Future<bool> clearAll() async {
    final prefs = sharedPreferences;
    final savedEmail = prefs.getString(PrefKeys.userEmail) ?? '';
    await prefs.clear();

    if (savedEmail.isNotEmpty) {
      await prefs.setString(PrefKeys.userEmail, savedEmail);
    }

    return true;
  }

  Future<void> setUserEmail(String userEmail) async {
    await sharedPreferences.setString(PrefKeys.userEmail, userEmail);
  }

  Future<String> getUserEmail() async {
    return sharedPreferences.getString(PrefKeys.userEmail) ?? '';
  }

  Future<bool> hasSeenWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenWelcome') ?? false;
  }

  Future<void> setHasSeenWelcome(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', value);
  }

  Future<void> setProfileBanStatus(String profileBanStatus) async {
    await sharedPreferences.setString(
      PrefKeys.profileBanStatus,
      profileBanStatus,
    );
  }

  Future<String> getProfileBanStatus() async {
    return sharedPreferences.getString(PrefKeys.profileBanStatus) ?? 'Pending';
  }

  Future<void> setSocialLinks(String portfolioLink) async {
    await sharedPreferences.setString(PrefKeys.socialLink, portfolioLink);
  }

  Future<String> getSocialLinks() async {
    return sharedPreferences.getString(PrefKeys.socialLink) ?? '';
  }

  Future<void> setDatabaseId(String id) async {
    await sharedPreferences.setString(PrefKeys.databaseId, id);
  }

  Future<String> getDatabaseId() async {
    return sharedPreferences.getString(PrefKeys.databaseId) ?? '';
  }

  Future<void> setCountry(String country) async {
    await sharedPreferences.setString(PrefKeys.country, country);
  }

  Future<String> getCountry() async {
    return sharedPreferences.getString(PrefKeys.country) ?? '';
  }

  Future<void> setDob(String dob) async {
    await sharedPreferences.setString(PrefKeys.dob, dob);
  }

  Future<String> getDob() async {
    return sharedPreferences.getString(PrefKeys.dob) ?? '';
  }

  Future<void> setGender(String gender) async {
    await sharedPreferences.setString(PrefKeys.gender, gender);
  }

  Future<String> getGender() async {
    return sharedPreferences.getString(PrefKeys.gender) ?? '';
  }
  Future<void> setFollowersCount(int count) async {
    await sharedPreferences.setInt('followersCount', count);
  }

  Future<int> getFollowersCount() async {
    return sharedPreferences.getInt('followersCount') ?? 0;
  }

  Future<void> setIsVerified(bool isVerified) async {
    await sharedPreferences.setBool(PrefKeys.isVerifiedKey, isVerified);
  }

  Future<bool> getIsVerified() async {
    return sharedPreferences.getBool(PrefKeys.isVerifiedKey) ?? false;
  }

}

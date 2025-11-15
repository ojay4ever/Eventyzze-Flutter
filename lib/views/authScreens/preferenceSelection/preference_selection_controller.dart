import 'package:eventyzze/cache/shared_preferences_helper.dart';
import 'package:eventyzze/config/get_it.dart';
import 'package:eventyzze/customWidgets/home_tab.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/repositories/profileRepository/profile_repository.dart';
import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:eventyzze/views/homeScreens/home_page_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:eventyzze/services/socket_service.dart';

class PreferenceSelectionController extends GetxController {
  final ProfileRepository _profileRepository = getIt<ProfileRepository>();
  final SharedPrefsHelper _sharedPrefsHelper = getIt<SharedPrefsHelper>();

  final RxList<String> selectedItems = <String>[].obs;
  final RxBool isLoading = false.obs;
  final int maxSelections = 4;

  void toggleSelection(String item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      if (selectedItems.length < maxSelections) {
        selectedItems.add(item);
      } else {
        CustomSnackBar.warning(
          title: 'Limit Reached',
          message: 'You can select maximum $maxSelections preferences.',
        );
      }
    }
  }

  bool isSelected(String item) {
    return selectedItems.contains(item);
  }

  Future<void> savePreferencesAndContinue() async {
    if (selectedItems.isEmpty) {
      CustomSnackBar.error(
        title: 'Validation Error',
        message: 'Please select at least one preference.',
      );
      return;
    }

    if (selectedItems.length > maxSelections) {
      CustomSnackBar.error(
        title: 'Validation Error',
        message: 'You can select maximum $maxSelections preferences.',
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        CustomSnackBar.error(
          title: 'Error',
          message: 'User not authenticated. Please login again.',
        );
        isLoading.value = false;
        return;
      }

      final updateData = <String, dynamic>{
        'preferences': selectedItems.toList(),
      };

      final updatedProfile = await _profileRepository.updateProfileData(
        updateData,
      );

      if (updatedProfile != null) {
        final dbId = await _sharedPrefsHelper.getDatabaseId();
        if (dbId.isNotEmpty) {
          final fetchedUser = await _profileRepository.getProfile(dbId);

          if (fetchedUser != null) {
            final fcmToken = await FirebaseMessaging.instance.getToken();
            if (fcmToken != null && fcmToken.isNotEmpty) {
              Map<String, dynamic> req = {
                'fcmToken': fcmToken,
                'dbId': fetchedUser.dbId,
              };
              await _profileRepository.updateFcmToken(req);
            }

            SocketService().connect(fetchedUser.dbId);
          }
        }

        CustomSnackBar.success(
          title: 'Success',
          message: 'Profile setup completed!',
        );

        NavigationHelper.goToNavigatorScreen(Get.context!, HomeTab(), finish: true);
      } else {
        CustomSnackBar.error(
          title: 'Error',
          message: 'Failed to save preferences. Please try again.',
        );
      }
    } catch (e) {
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to save preferences: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}

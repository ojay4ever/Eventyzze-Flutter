import 'dart:io';
import 'package:eventyzze/cache/shared_preferences_helper.dart';
import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/config/get_it.dart';
import 'package:eventyzze/customWidgets/app_loading_dialog.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/repositories/profileRepository/profile_repository.dart';
import 'package:eventyzze/services/auth_services.dart';
import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:eventyzze/views/authScreens/preferenceSelection/preference_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/src/form_data.dart' as dio;
import 'package:dio/src/multipart_file.dart' as dio_file;

class ProfileSetupController extends GetxController {
  final ProfileRepository _profileRepository = getIt<ProfileRepository>();
  final SharedPrefsHelper _sharedPrefsHelper = getIt<SharedPrefsHelper>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString imageUrl = ''.obs;
  final RxList<String> selectedPreferences = <String>[].obs;
  final RxBool isSavingPreferences = false.obs;
  final int maxPreferences = 4;

  @override
  void onInit() {
    super.onInit();
    // Load existing preferences
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    try {
      final dbId = await _sharedPrefsHelper.getDatabaseId();
      if (dbId.isNotEmpty) {
        final profile = await _profileRepository.getProfile(dbId);
        if (profile != null && profile.preferences.isNotEmpty) {
          selectedPreferences.value = List<String>.from(profile.preferences);
        }
      }
    } catch (e) {
      // Silently fail - user might not have preferences yet
    }
  }

  void togglePreference(String preference) {
    // Normalize to lowercase for consistency (backend stores in lowercase)
    final normalizedPreference = preference.toLowerCase();

    // Check if already selected (case-insensitive)
    final existingIndex = selectedPreferences.indexWhere(
      (p) => p.toLowerCase() == normalizedPreference,
    );

    if (existingIndex != -1) {
      selectedPreferences.removeAt(existingIndex);
    } else {
      if (selectedPreferences.length < maxPreferences) {
        selectedPreferences.add(normalizedPreference);
      } else {
        CustomSnackBar.warning(
          title: 'Limit Reached',
          message: 'You can select maximum $maxPreferences preferences.',
        );
      }
    }
  }

  bool isPreferenceSelected(String preference) {
    // Compare case-insensitively since backend stores in lowercase
    return selectedPreferences.any(
      (selected) => selected.toLowerCase() == preference.toLowerCase(),
    );
  }

  String formatPreferenceForDisplay(String preference) {
    // Convert to title case for display
    if (preference.isEmpty) return preference;
    return preference
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  Future<void> showPreferencesBottomSheet() async {
    final List<String> allPreferences = [
      "Live concerts",
      "Live sport matches",
      "Technology",
      "Gaming",
      "Science",
      "Networking",
      "Fashion",
      "Beauty",
      "Fitness classes",
      "Art",
      "Cultural events",
      "Literature",
      "Seminars",
      "Nature",
      "Charity",
      "Cooking",
      "Dance",
      "Travel",
      "Movie premier",
      "Film festivals",
    ];

    await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        constraints: BoxConstraints(maxHeight: Get.height * 0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Builder(
              builder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Preferences',
                      style: Get.textTheme.displayLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            const Text(
              "Customize your recommendations and let us\nknow what you love (Select up to 4)",
              style: TextStyle(
                color: AppTheme.halfBlack,
                fontSize: 16,
                fontFamily: AppFonts.lato,
                fontWeight: FontWeight.w400,
              ),
            ),
            Obx(
              () => selectedPreferences.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Selected: ${selectedPreferences.length}/$maxPreferences',
                        style: TextStyle(
                          color: AppTheme.kPrimaryColor,
                          fontSize: 14,
                          fontFamily: AppFonts.lato,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            // Preferences list
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: allPreferences.map((item) {
                    return Obx(() {
                      final bool isSelected = isPreferenceSelected(item);
                      return GestureDetector(
                        onTap: () => togglePreference(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected
                                ? AppTheme.kPrimaryColor.withValues(alpha: 0.1)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.kPrimaryColor
                                  : const Color(0xFF949494),
                              width: isSelected ? 2 : 0.5,
                            ),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected
                                  ? AppTheme.kPrimaryColor
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontFamily: AppFonts.lato,
                            ),
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Save button
            CustomButton(
              text: 'Save',
              onTap: () {
                if (!isSavingPreferences.value) {
                  AppLoadingDialog.show(message: 'Saving preferences...');
                  savePreferences();
                }
              },
            ),
            SizedBox(height: Get.mediaQuery.padding.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future<void> savePreferences() async {
    try {
      isSavingPreferences.value = true;

      final updateData = <String, dynamic>{
        'preferences': selectedPreferences.toList(),
      };

      final updatedProfile = await _profileRepository.updateProfileData(
        updateData,
      );

      if (updatedProfile != null) {
        AppLoadingDialog.hide();
        CustomSnackBar.success(
          title: 'Success',
          message: 'Preferences updated successfully!',
        );
        // Delay slightly to avoid conflict with snackbar
        Future.delayed(const Duration(milliseconds: 100), () {
          if (Get.isBottomSheetOpen == true) {
            Navigator.of(Get.overlayContext!).pop();
          }
        });
      } else {
        AppLoadingDialog.hide();
        CustomSnackBar.error(
          title: 'Error',
          message: 'Failed to save preferences. Please try again.',
        );
      }
    } catch (e) {
      AppLoadingDialog.hide();
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to save preferences: ${e.toString()}',
      );
    } finally {
      isSavingPreferences.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    bioController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to pick image: ${e.toString()}',
      );
    }
  }

  Future<void> takePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to take picture: ${e.toString()}',
      );
    }
  }

  Future<void> showImageSourceDialog() async {
    await Get.dialog(
      Builder(
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImage();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    takePicture();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> saveProfileAndContinue() async {
    try {
      isUpdating.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        CustomSnackBar.error(
          title: 'Error',
          message: 'User not authenticated. Please login again.',
        );
        isUpdating.value = false;
        return;
      }

      // Ensure token is available before making the request
      final token = await AuthService().getBearerToken();
      if (token == null || token.isEmpty) {
        CustomSnackBar.error(
          title: 'Authentication Error',
          message:
              'Unable to get authentication token. Please try logging in again.',
        );
        isUpdating.value = false;
        return;
      }

      final formData = dio.FormData();

      if (usernameController.text.trim().isNotEmpty) {
        formData.fields.add(
          MapEntry('username', usernameController.text.trim()),
        );
      }

      if (bioController.text.trim().isNotEmpty) {
        formData.fields.add(MapEntry('bio', bioController.text.trim()));
      }

      if (selectedImage.value != null) {
        final file = selectedImage.value!;
        final fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            'profilePhoto',
            await dio_file.MultipartFile.fromFile(
              file.path,
              filename: fileName,
            ),
          ),
        );
      }

      final updatedProfile = await _profileRepository.updateProfile(formData);

      if (updatedProfile != null) {
        AppLoadingDialog.hide();
        NavigationHelper.goToNavigatorScreen(
          Get.context!,
          PreferenceSelectionScreen(),
        );
      } else {
        AppLoadingDialog.hide();
        CustomSnackBar.error(
          title: 'Error',
          message: 'Failed to save profile. Please try again.',
        );
      }
    } catch (e) {
      AppLoadingDialog.hide();
      CustomSnackBar.error(
        title: 'Error',
        message: 'Failed to save profile: ${e.toString()}',
      );
    } finally {
      isUpdating.value = false;
    }
  }
}

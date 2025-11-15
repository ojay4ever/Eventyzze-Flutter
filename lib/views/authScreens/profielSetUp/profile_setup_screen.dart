import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/customWidgets/app_loading_dialog.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/customWidgets/custom_text_field.dart';
import 'package:eventyzze/views/authScreens/profielSetUp/profile_setup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_utils.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.init(context);
    final controller = Get.put(ProfileSetupController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: CustomScreenUtil.height(12)),
                  Center(
                    child: Obx(
                      () => Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFF000000,
                              ).withValues(alpha: 0.4),
                              border: Border.all(
                                color: AppTheme.kPrimaryColor,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: controller.selectedImage.value != null
                                  ? Image.file(
                                      controller.selectedImage.value!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 70,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.showImageSourceDialog,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.kPrimaryColor,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    "Username",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Set a username that would be visible to others",
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Username (optional)',
                    controller: controller.usernameController,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Bio",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tell us a little bit about yourself",
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.bioController,
                    hintText: 'Tell us about yourself (optional)',
                    maxLines: 9,
                    maxLength: 500,
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: controller.bioController,
                    builder: (context, value, child) {
                      return Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${value.text.length}/500',
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: const Color(0xFF797979),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Next',
                    onTap: () {
                      if (!controller.isUpdating.value) {
                        AppLoadingDialog.show(message: 'Saving profile...');
                        controller.saveProfileAndContinue();
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

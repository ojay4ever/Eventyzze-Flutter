import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/config/app_utils.dart';
import 'package:eventyzze/customWidgets/app_loading_dialog.dart';
import 'package:eventyzze/customWidgets/app_loading_indicator.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/customWidgets/custom_logout_dialog.dart';
import 'package:eventyzze/customWidgets/custom_text_field.dart';
import 'package:eventyzze/views/profileScreens/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.init(context);
    final controller = Get.put(ProfileController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightBlacks,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.error),
            onPressed: () async {
              final result = await CustomLogoutDialog.show(context);
              if (result == true) {
                await controller.logout();
              }
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoadingIndicator(message: 'Loading profile...');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() {
                    final imageUrl = controller.imageUrl.value;
                    final selectedImage = controller.selectedImage.value;

                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.greyLight,
                        border: Border.all(
                          color: AppTheme.kPrimaryColor,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: selectedImage != null
                            ? Image.file(selectedImage, fit: BoxFit.cover)
                            : imageUrl.isNotEmpty &&
                                  !imageUrl.startsWith('/') &&
                                  !imageUrl.startsWith('file://')
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildDefaultAvatar(),
                              )
                            : _buildDefaultAvatar(),
                      ),
                    );
                  }),
                  // Edit Icon Button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.kPrimaryColor,
                      border: Border.all(color: AppTheme.white, width: 3),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: controller.showImageSourceDialog,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppTheme.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Name Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightBlacks,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter your name',
                controller: controller.nameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 32),
              // Bio Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bio',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightBlacks,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Tell us about yourself (optional)',
                controller: controller.bioController,
                maxLines: 5,
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
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF797979),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Email Field (Read-only)
              if (controller.userProfile.value?.email != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightBlacks,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Email',
                  controller: TextEditingController(
                    text: controller.userProfile.value?.email ?? '',
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 32),
              ],
              // Preferences Section
              Obx(() {
                final preferences = controller.selectedPreferences;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Preferences',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightBlacks,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: controller.showPreferencesBottomSheet,
                          icon: const Icon(
                            Icons.edit,
                            size: 18,
                            color: AppTheme.kPrimaryColor,
                          ),
                          label: const Text(
                            'Edit',
                            style: TextStyle(
                              color: AppTheme.kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (preferences.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'No preferences selected',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF797979),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: preferences.map((pref) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppTheme.kPrimaryColor.withValues(
                                alpha: 0.1,
                              ),
                              border: Border.all(
                                color: AppTheme.kPrimaryColor,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              controller.formatPreferenceForDisplay(pref),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 32),
                  ],
                );
              }),
              // Save Button
              CustomButton(
                text: 'Save Changes',
                onTap: () {
                  if (!controller.isUpdating.value) {
                    AppLoadingDialog.show(message: 'Updating profile...');
                    controller.updateProfile();
                  }
                },
                backgroundColor: AppTheme.kPrimaryColor,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppTheme.kPrimaryColor.withValues(alpha: 0.1),
      child: const Icon(Icons.person, size: 60, color: AppTheme.kPrimaryColor),
    );
  }
}

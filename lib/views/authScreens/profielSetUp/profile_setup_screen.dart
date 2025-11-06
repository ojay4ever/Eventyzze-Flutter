import 'package:eventyzze/customWidget/custom_button.dart';
import 'package:eventyzze/customWidget/custom_text_field.dart';
import 'package:eventyzze/enums/enums.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/views/authScreens/preferenceSelection/preference_selection_screen.dart';
import 'package:flutter/material.dart';
import '../../../config/app_utils.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _bioController = TextEditingController();
  final int _maxBioLength = 500;

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.init(context);
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
                  SizedBox(height: 12.h),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF000000).withValues(alpha: 0.4),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                        const Icon(Icons.edit, size: 18, color: Colors.grey),
                      ],
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
                    "Set a name that would be visible to others",
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  const CustomTextField(hintText: 'Username'),
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
                    controller: _bioController,
                    hintText: 'Eventyze',
                    maxLines: 9,
                    maxLength: _maxBioLength,
                  ),
                  SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: _bioController,
                    builder: (context, value, child) {
                      return Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${value.text.length}/$_maxBioLength',
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: Color(0xFF797979),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    text: 'Next',
                    onTap: () {
                      NavigationHelper.goToNavigatorScreen(
                        context,
                        PreferenceSelectionScreen(),
                      );
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

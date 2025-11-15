import 'package:eventyzze/customWidgets/app_loading_indicator.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/views/authScreens/preferenceSelection/preference_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_font.dart';
import '../../../config/app_theme.dart';

class PreferenceSelectionScreen extends StatelessWidget {
  const PreferenceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PreferenceSelectionController());
    final theme = Theme.of(context);

    final List<String> interests = [
      "Live concerts",
      "Live sport matches",
      "Technology",
      "Gaming",
      "Science",
      "Networking",
      "Fashion",
      "Beauty",
      "Fitness classes",
      "Fashion",
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Select Preferences',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ],
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
                () => controller.selectedItems.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Selected: ${controller.selectedItems.length}/${controller.maxSelections}',
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
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 12,
                    children: interests.map((item) {
                      return Obx(() {
                        final bool isSelected = controller.isSelected(item);
                        return GestureDetector(
                          onTap: () => controller.toggleSelection(item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isSelected
                                  ? AppTheme.kPrimaryColor.withValues(
                                      alpha: 0.1,
                                    )
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
              Obx(
                () => controller.isLoading.value
                    ? const AppLoadingIndicator(
                        message: 'Saving preferences...',
                      )
                    : CustomButton(
                        text: "Continue",
                        onTap: controller.savePreferencesAndContinue,
                      ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

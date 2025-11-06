import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/views/authScreens/signUpScreen/sign_up_last_screen.dart';
import 'package:flutter/material.dart';

import '../../../config/app_font.dart';
import '../../../config/app_theme.dart';
import '../../../customWidget/custom_button.dart';

class PreferenceSelectionScreen extends StatefulWidget {
  const PreferenceSelectionScreen({super.key});

  @override
  State<PreferenceSelectionScreen> createState() =>
      _PreferenceSelectionScreenState();
}

class _PreferenceSelectionScreenState extends State<PreferenceSelectionScreen> {
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

  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                    onTap: () {
                      NavigationHelper.goBackToPreviousPage(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Profile Setup',
                    style: theme.textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Customize your recommendations and let us\nknow what you love",
                style: TextStyle(
                  color: AppTheme.halfBlack,
                  fontSize: 16,
                  fontFamily: AppFonts.lato,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 12,
                    children: interests.map((item) {
                      final bool isSelected = selectedItems.contains(item);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected
                                ? selectedItems.remove(item)
                                : selectedItems.add(item);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected
                                ? Colors.orange.shade100
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange
                                  : Color(0xFF949494),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected
                                  ? Colors.orange.shade800
                                  : Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.lato,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              CustomButton(text: "Next", onTap: () {
                NavigationHelper.goToNavigatorScreen(context, SignUpLastScreen());
              }),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

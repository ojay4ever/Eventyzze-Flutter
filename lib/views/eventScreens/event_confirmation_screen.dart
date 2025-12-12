import 'package:eventyzze/config/app_images.dart';
import 'package:eventyzze/customWidgets/app_loading_dialog.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/customWidgets/custom_text_field.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_font.dart';
import 'event_creation_confirmation.dart';

class EventConfirmationScreen extends StatefulWidget {
  const EventConfirmationScreen({super.key});

  @override
  State<EventConfirmationScreen> createState() =>
      _EventConfirmationScreenState();
}

class _EventConfirmationScreenState extends State<EventConfirmationScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _paymentDetailsController =
      TextEditingController();
  final List<TextEditingController> _socialMediaControllers = [
    TextEditingController(),
  ];

  @override
  void dispose() {
    _priceController.dispose();
    _paymentDetailsController.dispose();
    for (var controller in _socialMediaControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSocialMediaField() {
    setState(() {
      _socialMediaControllers.add(TextEditingController());
    });
  }

  void _removeSocialMediaField(int index) {
    if (_socialMediaControllers.length > 1) {
      setState(() {
        _socialMediaControllers[index].dispose();
        _socialMediaControllers.removeAt(index);
      });
    }
  }

  // void _confirmEvent() {
  //   if (_priceController.text.trim().isEmpty) {
  //     CustomSnackBar.error(
  //       title: 'Error',
  //       message: 'Please enter the event price',
  //     );
  //     return;
  //   }
  //   if (_paymentDetailsController.text.trim().isEmpty) {
  //     CustomSnackBar.error(
  //       title: 'Error',
  //       message: 'Please enter the payment details',
  //     );
  //     return;
  //   }
  //
  //   AppLoadingDialog.show(message: 'Confirming event...');
  //   Future.delayed(const Duration(seconds: 2), () {
  //     AppLoadingDialog.hide();
  //     CustomSnackBar.success(
  //       title: 'Success',
  //       message: 'Event confirmed successfully!',
  //     );
  //     Get.back();
  //     Get.back();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(width),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildInfoSection(),
                  const SizedBox(height: 6),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 20),
                  _buildLabel('Set price for Event'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Input Price',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Payment Details'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Set Payment Details',
                    controller: _paymentDetailsController,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Social Media URL'),
                  const SizedBox(height: 8),
                  _buildSocialMediaSection(),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Confirm',
                    onTap: () {
                      NavigationHelper.goToNavigatorScreen(
                        context,
                        const EventCreationConfirmation(),
                      );
                    },
                    backgroundColor: const Color(0xFFFF6B35),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
    return Stack(
      children: [
        Container(
          height: 320,
          width: width,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
            image: DecorationImage(
              image: AssetImage(AppImages.confirmation),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 320,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.4), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shine On Music Festival',
          style: TextStyle(
            fontSize: 20,
            fontFamily: AppFonts.inter,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildIconTextRow(Icons.calendar_today_outlined, '24th Sept. 2024'),
        const SizedBox(height: 8),
        _buildIconTextRow(Icons.access_time, '8:00pm'),
        const SizedBox(height: 20),
        const Text(
          'Description:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: AppFonts.lato,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            text:
                'Lorem ipsum sit dolor amet, consectur adispiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ut enim ad minim veniam... ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
              fontFamily: AppFonts.lato,
            ),
            children: const [
              TextSpan(
                text: 'Read More',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
            fontFamily: AppFonts.inter,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      children: [
        ...List.generate(_socialMediaControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: 'Enter URL',
                    controller: _socialMediaControllers[index],
                  ),
                ),
                if (_socialMediaControllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _removeSocialMediaField(index),
                  ),
              ],
            ),
          );
        }),
        Center(
          child: TextButton(
            onPressed: _addSocialMediaField,
            child: Text(
              '+ Add',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: AppFonts.lato,
        color: Colors.black,
      ),
    );
  }
}

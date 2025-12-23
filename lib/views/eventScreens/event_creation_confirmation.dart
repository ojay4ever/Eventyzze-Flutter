import 'package:eventyzze/config/app_images.dart';
import 'package:eventyzze/constants/enums.dart';
import 'package:eventyzze/customWidgets/custom_button.dart';
import 'package:eventyzze/customWidgets/home_tab.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/model/event_model.dart';
import 'package:flutter/material.dart';
import '../../config/app_font.dart';

class EventCreationConfirmation extends StatelessWidget {
  final EventModel event;
  
  const EventCreationConfirmation({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [_buildTicketCard(),
            const SizedBox(height: 10),
            _buildSuccessText(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  Widget _buildTicketCard() {
    return SizedBox(
      height: 94.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 9.h,
            left: 1.8.w,
            right: 1.8.w,
            child: Container(
              height: 80.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCACACA),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          Positioned(
            top: 11.h,
            left: 5.w,
            right: 5.w,
            child: Container(
              height: 33.h,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: _buildEventImage(),
              ),
            ),
          ),
          Positioned(
            top: 45.h,
            left: 5.w,
            right: 5.w,
            child: Container(
              height: 42.h,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 2.3.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "${event.date}\n${event.time}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 1.5.h,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  Row(
                    children: List.generate(
                      150 ~/ 3,
                          (index) => Expanded(
                        child: Container(
                          color: index % 2 == 0
                              ? Colors.transparent
                              : Colors.grey[300],
                          height: 0.2.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    event.description,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Read More",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF8038),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.8.h),
                  const Text(
                    "5,000 NGN (Early birds)",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: AppFonts.inter,
                    ),
                  ),
                  SizedBox(height: 2.5.h),
                ],
              ),
            ),
          ),
          Positioned(
            top: 76.h,
            left: 1.8.w,
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCACACA),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            top: 76.h,
            right: 1.7.w,
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCACACA),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessText() {
    return const Text(
      "Event created successfully!",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildEventImage() {
    final imageUrl = event.advertisementUrl != null && 
                     event.advertisementUrl!.trim().isNotEmpty
        ? event.advertisementUrl!.trim()
        : (event.organizerProfilePicture != null && 
           event.organizerProfilePicture!.trim().isNotEmpty
            ? event.organizerProfilePicture!.trim()
            : null);

    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppImages.confirmation,
            fit: BoxFit.cover,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }

    return Image.asset(
      AppImages.confirmation,
      fit: BoxFit.cover,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "Continue",
              backgroundColor: const Color(0xFFFF8038),
              textColor: Colors.white,
              onTap: () {
                NavigationHelper.goToNavigatorScreen(context, HomeTab());
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: "Share",
              backgroundColor: Colors.white,
              borderColor: const Color(0xFFFF8038),
              textColor: Colors.black,
              onTap: () {
                _showShareModal(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showShareModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Share with :',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: AppFonts.inter,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(
                    icon: AppImages.facebook,
                    label: 'Facebook',
                    onTap: () {
                      // Handle Facebook share
                      Navigator.pop(context);
                    },
                  ),
                  _buildShareOption(
                    icon: AppImages.instagram,
                    label: 'Instagram',
                    onTap: () {
                      // Handle Instagram share
                      Navigator.pop(context);
                    },
                  ),
                  _buildShareOption(
                    icon: AppImages.tiktok,
                    label: 'TikTok',
                    onTap: () {
                      // Handle TikTok share
                      Navigator.pop(context);
                    },
                  ),
                  _buildShareOption(
                    icon: AppImages.link,
                    label: 'Copy Link',
                    onTap: () {
                      // Handle Copy Link
                      Navigator.pop(context);
                    },
                  ),
                  _buildShareOption(
                    icon: AppImages.download,
                    label: 'Download',
                    onTap: () {
                      // Handle Download
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              icon,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.inter,
            ),
          ),
        ],
      ),
    );
  }
}
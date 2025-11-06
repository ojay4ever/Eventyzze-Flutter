import 'package:eventyzze/enums/enums.dart';
import 'package:flutter/material.dart';

import '../config/app_font.dart';

class CustomEventCard extends StatelessWidget {
  final String title;
  final String artist;
  final String date;
  final String time;
  final String backgroundImage;
  final String artistImage;
  final VoidCallback? onTap;

  const CustomEventCard({
    super.key,
    required this.title,
    required this.artist,
    required this.date,
    required this.time,
    required this.backgroundImage,
    required this.artistImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 27.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF1B4E8C), Color(0xFF12355F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              backgroundImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.10),
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
          Positioned(
            top: 2.h,
            left: 4.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.lato,
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  artist,
                  style: const TextStyle(
                    fontFamily: AppFonts.lato,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 1.2.h),
                Text(
                  "Event day: $date\nTime: $time",
                  style: const TextStyle(
                    fontFamily: AppFonts.inter,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 1.1.h),
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 32.w,
                    height: 4.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.white.
                          withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "View event",
                      style: TextStyle(
                        fontFamily: AppFonts.lato,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            right: -3.h,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(12),
              ),
              child: Image.asset(
                artistImage,
                width: 40.w,
                height: 38.h,
                fit: BoxFit.cover,
                alignment: Alignment.bottomRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

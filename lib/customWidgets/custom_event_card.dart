import 'package:eventyzze/enums/enums.dart';
import 'package:flutter/material.dart';
import '../config/app_font.dart';
import '../config/app_images.dart';

class CustomEventCard extends StatelessWidget {
  final String title;
  final String artist;
  final String date;
  final String time;
  final String backgroundImage;
  final String artistImage;
  final int price;
  final VoidCallback? onTap;

  const CustomEventCard({
    super.key,
    required this.title,
    required this.artist,
    required this.date,
    required this.time,
    required this.backgroundImage,
    required this.artistImage,
    this.price = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30.h,
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
              width: 100.w,
              height: 30.h,
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.10),
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
          Positioned(
            top: 2.h,
            left: 4.w,
            child: SizedBox(
              width: 55.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      fontWeight: FontWeight.w700,
                      fontSize: 4.h,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 0.5.h),

                  Text(
                    artist,
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      fontWeight: FontWeight.w500,
                      fontSize: 2.3.h,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.2.h),

                  Text(
                    "Event day: $date\\nTime: $time",
                    style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontWeight: FontWeight.w400,
                      fontSize: 1.5.h,
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
                          color: Colors.white.withValues(alpha: 0.7),
                          width: 0.2.w,
                        ),
                      ),
                      child: Text(
                        "View event",
                        style: TextStyle(
                          fontFamily: AppFonts.lato,
                          fontWeight: FontWeight.w400,
                          fontSize: 1.7.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
          if (price > 0)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$price',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomEventCardWithNetwork extends StatelessWidget {
  final String title;
  final String artist;
  final String date;
  final String time;
  final String backgroundImage;
  final String? artistImageUrl;
  final int price;
  final VoidCallback? onTap;

  const CustomEventCardWithNetwork({
    super.key,
    required this.title,
    required this.artist,
    required this.date,
    required this.time,
    required this.backgroundImage,
    this.artistImageUrl,
    this.price = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30.h,
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
              width: 100.w,
              height: 30.h,
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.10),
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
          Positioned(
            top: 2.h,
            left: 4.w,
            child: SizedBox(
              width: 55.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      fontWeight: FontWeight.w700,
                      fontSize: 4.h,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),

                  Text(
                    artist,
                    style: TextStyle(
                      fontFamily: AppFonts.lato,
                      fontWeight: FontWeight.w500,
                      fontSize: 2.3.h,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),

                  Text(
                    "Event day: $date\nTime: $time",
                    style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontWeight: FontWeight.w400,
                      fontSize: 1.5.h,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
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
                          color: Colors.white.withValues(alpha: 0.7),
                          width: 0.2.w,
                        ),
                      ),
                      child: Text(
                        "View event",
                        style: TextStyle(
                          fontFamily: AppFonts.lato,
                          fontWeight: FontWeight.w400,
                          fontSize: 1.7.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -3.h,
            child: artistImageUrl != null && artistImageUrl!.isNotEmpty
                ? Image.network(
              artistImageUrl!,
              width: 40.w,
              height: 22.h,
              fit: BoxFit.cover,
              alignment: Alignment.bottomRight,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AppImages.singingMen,
                  width: 40.w,
                  height:  22.h,
                  fit: BoxFit.fill,
                  alignment: Alignment.bottomRight,
                );
              },
            )
                : Image.asset(
              AppImages.singingMen,
              width: 40.w,
              height: 38.h,
              fit: BoxFit.cover,
              alignment: Alignment.bottomRight,
            ),
          )
,
          if (price > 0)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$price',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

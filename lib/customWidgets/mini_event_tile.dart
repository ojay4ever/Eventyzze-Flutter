import 'package:eventyzze/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:eventyzze/config/app_font.dart';

class MiniEventTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isAsset;
  final int price;

  const MiniEventTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isAsset = true,
    this.price = 0,
  });

  @override
  Widget build(BuildContext context) {
    final img = isAsset
        ? Image.asset(imagePath, fit: BoxFit.cover)
        : Image.network(imagePath, fit: BoxFit.cover);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30.w,
            height: 9.h,
            child: img,
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.lato,
                    fontWeight: FontWeight.w700,
                    fontSize: 1.4.h,
                    height: 1.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.lato,
                    fontWeight: FontWeight.w400,
                    fontSize: 1.4.h,
                    height: 1.0,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
                if (price > 0) ...[
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '$price Coins',
                        style: TextStyle(
                          fontFamily: AppFonts.lato,
                          fontWeight: FontWeight.w600,
                          fontSize: 1.2.h,
                          color: Colors.amber[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

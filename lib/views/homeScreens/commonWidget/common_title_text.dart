import 'package:flutter/material.dart';
import '../../../config/app_font.dart';
import '../../../config/app_theme.dart';
class CommonTitleText extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const CommonTitleText({
    super.key,
    required this.title,
    this.fontSize = 20,
    this.color,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppFonts.inter,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color ?? AppTheme.lightBlacks,
      ),
    );
  }
}

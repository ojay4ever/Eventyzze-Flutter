import 'package:flutter/material.dart';

import '../config/app_font.dart';
import '../config/app_theme.dart';

class CustomElevatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? textColor;
  final double borderRadius;
  final double padding;
  final double fontSize;
  final FontWeight fontWeight;
  final String? fontFamily;
  final Color? fontColor;
  final bool isLoading;
  final Color? borderColor;
  final List<Color>? gradientColors;
  final Color? shadowColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.textColor,
    this.fontFamily,
    this.borderRadius = 50.0,
    this.padding = 14.0,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.fontColor,
    this.isLoading = false,
    this.borderColor,
    this.gradientColors,
    this.shadowColor,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: InkWell(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.padding + 7,
            vertical: widget.padding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: widget.gradientColors ??
                   [
                     AppTheme.kPrimaryColor,
                    Colors.black,
                  ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              if (widget.shadowColor != null)
                BoxShadow(
                  color: widget.shadowColor!,
                  offset: const Offset(2, 2),
                  blurRadius: 0,
                  spreadRadius: 0,
                )
              else
                const BoxShadow(
                  color: Color(0xFFB03544),
                  offset: Offset(2, 2),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
            ],
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 1.5)
                : null,
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 20,
                    color: widget.fontColor ??
                        widget.textColor ??
                        Colors.white,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.fontColor ??
                        widget.textColor ??
                        Colors.white,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                    fontFamily: widget.fontFamily
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

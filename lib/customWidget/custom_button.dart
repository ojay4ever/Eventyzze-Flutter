import 'package:eventyzze/config/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool showLoader;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? imagePath;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.showLoader = false,
    this.backgroundColor,
    this.borderColor,
    this.imagePath,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (widget.showLoader) return;
    await _controller.forward();
    await _controller.reverse();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? const Color(0xFFFF8038),
            borderRadius: BorderRadius.circular(26),
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 2)
                : null,
          ),
          child: Center(
            child: widget.showLoader
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.imagePath != null) ...[
                  SvgPicture.asset(
                    widget.imagePath!,
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: AppFonts.lato,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
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

import 'package:flutter/material.dart';
import '../config/app_font.dart';
import '../config/app_theme.dart';

// Converted to a StatefulWidget to correctly manage the controller's listener.
class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines,
    this.maxLength,
    this.keyboardType,
    this.obscureText,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final GlobalKey<FormFieldState<String>> _formFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);
    }
  }

  void _handleControllerChanged() {
    if (_formFieldKey.currentState?.value != widget.controller?.text) {
      _formFieldKey.currentState?.didChange(widget.controller!.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FormField<String>(
      key: _formFieldKey,
      validator: widget.validator,
      initialValue: widget.controller?.text,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                left: 8,
                right: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFC9C9C9),
                  width: 0.5,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                readOnly: widget.readOnly,
                onTap: widget.onTap,
                onChanged: (val) => state.didChange(val),
                maxLines: widget.obscureText == true ? 1 : widget.maxLines,
                maxLength: widget.maxLength,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText ?? false,
                style: TextStyle(
                  fontFamily: AppFonts.lato,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: const Color(0xFF555555).withValues(alpha: 0.5),
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF555555).withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                  suffixIcon: widget.suffixIcon,
                  prefixIcon: widget.prefixIcon,
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    state.errorText ?? "",
                    style: const TextStyle(
                      fontFamily: AppFonts.lato,
                      fontSize: 9,
                      color: AppTheme.error,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

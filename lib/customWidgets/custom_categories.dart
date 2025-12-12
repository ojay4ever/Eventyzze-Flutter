import 'package:eventyzze/enums/enums.dart';
import 'package:flutter/material.dart';
import '../config/app_font.dart';

class CustomCategories extends StatefulWidget {
  final Function(String) onSelected;
  final List<String> categories;

  const CustomCategories({
    super.key,
    required this.onSelected,
    required this.categories,
  });

  @override
  State<CustomCategories> createState() => _CustomCategoriesState();
}

class _CustomCategoriesState extends State<CustomCategories> {
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categories.isNotEmpty ? widget.categories.first : '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4.3.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final label = widget.categories[index];
          final isSelected = label == selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = label;
              });
              widget.onSelected(label);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:  EdgeInsets.symmetric(
                horizontal: 1.8.h,
                vertical: 1.1.w,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF8038)
                    : const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(29),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.lato,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isSelected ? Colors.black : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

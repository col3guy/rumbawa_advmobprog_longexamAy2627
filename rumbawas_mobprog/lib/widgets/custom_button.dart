import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_font.dart';

class CustomButton extends StatelessWidget {
  // 🔹 PROFILE BUTTON PROPS
  final String? buttonName;
  final String buttonType;
  final VoidCallback? onPressed;

  // 🔹 NEWSFEED BUTTON PROPS
  final IconData? icon;
  final String? label;
  final VoidCallback? onTap;

  // 🔹 COMMON
  final Color fontColor;
  final Color outlineColor;

  const CustomButton({
    super.key,

    // profile button
    this.buttonName,
    this.onPressed,
    this.buttonType = 'elevated',

    // reaction button
    this.icon,
    this.label,
    this.onTap,

    // styles
    this.fontColor = Colors.black,
    this.outlineColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 CASE 1: NEWSFEED REACTION BUTTON
    if (icon != null && label != null && onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18.sp, color: Colors.grey[700]),
              SizedBox(width: 6.w),
              CustomFont(
                text: label!,
                fontSize: 12.sp,
                color: Colors.grey[700]!,
              ),
            ],
          ),
        ),
      );
    }

    // 🔥 CASE 2: PROFILE BUTTON
    final type = buttonType.toLowerCase();

    if (type == 'outlined') {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: outlineColor),
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: CustomFont(
          text: buttonName ?? '',
          fontSize: 12.sp,
          color: fontColor,
        ),
      );
    }

    if (type == 'text') {
      return TextButton(
        onPressed: onPressed,
        child: CustomFont(
          text: buttonName ?? '',
          fontSize: 12.sp,
          color: fontColor,
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: CustomFont(
        text: buttonName ?? '',
        fontSize: 12.sp,
        color: fontColor,
      ),
    );
  }
}

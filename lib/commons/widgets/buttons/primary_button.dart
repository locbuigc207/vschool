import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/gen/colors.gen.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final EdgeInsets? padding;
  final double borderRadius;
  final bool enabled;

  const PrimaryButton({
    Key? key,
    this.onTap,
    required this.title,
    this.padding,
    this.borderRadius = 12.0,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: enabled ? null : Colors.grey.shade300,
        gradient: enabled
            ? const LinearGradient(
                colors: <Color>[
                  ColorName.primaryGradientEnd,
                  ColorName.primaryColor,
                ],
              )
            : null,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: enabled ? Colors.white : Colors.grey.shade600, padding: padding ??
              EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
          visualDensity: VisualDensity.standard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: enabled ? Colors.white : Colors.grey.shade600,
              ),
        ),
      ),
    );
  }
}

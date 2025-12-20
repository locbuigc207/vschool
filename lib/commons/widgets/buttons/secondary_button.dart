import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/gen/colors.gen.dart';

class SecondaryButton extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final Widget? icon;
  final EdgeInsets? padding;
  final double borderRadius;
  final bool enabled;

  const SecondaryButton({
    Key? key,
    this.onTap,
    this.title = 'Huỷ',
    this.icon,
    this.padding,
    this.borderRadius = 12.0,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: enabled ? ColorName.textGray2 : Colors.grey.shade600, backgroundColor: enabled ? null : Colors.grey.shade300,
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
        visualDensity: VisualDensity.standard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: BorderSide(
          color: enabled ? ColorName.textGray2 : Colors.grey.shade600,
          width: 1.0,
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? const SizedBox.shrink(),
          if (icon != null) SizedBox(width: 4.w),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: enabled ? ColorName.textGray1 : Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }
}

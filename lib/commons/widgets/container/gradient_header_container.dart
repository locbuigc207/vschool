import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/gen/colors.gen.dart';

class GradientHeaderContainer extends StatelessWidget {
  final double? height;
  final double radius;

  const GradientHeaderContainer({
    super.key,
    this.height,
    this.radius = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
        gradient: const LinearGradient(
          colors: [
            ColorName.backgroundCardTopStart,
            ColorName.backgroundCardTopEnd,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

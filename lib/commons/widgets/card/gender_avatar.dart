import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

class GenderAvatar extends StatelessWidget {
  final bool gender;
  final double? height;
  final double? width;

  const GenderAvatar({
    Key? key,
    required this.gender,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
          shape: BoxShape.circle,
        ),
        child: gender == true
            ? Assets.images.avatarMale.svg(
                height: height ?? 48.r,
                width: width ?? 48.r,
                colorFilter:
                    ColorFilter.mode(ColorName.primaryColor, BlendMode.srcIn),
              )
            : Assets.images.avatarFemale.svg(
                height: height ?? 48.r,
                width: width ?? 48.r,
                colorFilter:
                    ColorFilter.mode(ColorName.primaryColor, BlendMode.srcIn),
              ));
  }
}

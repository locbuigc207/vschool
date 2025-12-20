import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/widgets/card/gender_avatar.dart';

class AvatarWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final bool? gender;

  const AvatarWidget({
    Key? key,
    this.height,
    this.width,
    this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenderAvatar(
      gender: gender ?? true,
      height: height ?? 48.r,
      width: 48.r,
    );
  }
}

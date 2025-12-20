import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/gen/colors.gen.dart';

class TextFieldCircularProgressIndicator extends StatelessWidget {
  const TextFieldCircularProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.h,
      width: 16.h,
      child: const CircularProgressIndicator(
        color: ColorName.primaryColor,
        strokeWidth: 3,
      ),
    );
  }
}

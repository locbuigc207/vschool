import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/widgets/buttons/primary_button.dart';
import 'package:vschool/gen/colors.gen.dart';

class LoadingPrimaryButton extends StatelessWidget {
  const LoadingPrimaryButton({
    Key? key,
    required this.title,
    this.onTap,
    this.isLoading = false,
    this.enabled = true,
    this.height,
    required,
  }) : super(key: key);

  final String title;
  final void Function()? onTap;
  final bool isLoading;
  final bool enabled;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: SizedBox(
        height: height ?? 56.h,
        width: double.infinity,
        child: PrimaryButton(
          title: title,
          onTap: onTap,
          enabled: enabled,
          // padding: EdgeInsets.symmetric(
          //   horizontal: 20.w,
          //   vertical: 16.h,
          // ),
          borderRadius: 16.0,
        ),
      ),
      secondChild: Container(
        height: height ?? 56.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: const LinearGradient(
            colors: <Color>[
              ColorName.primaryGradientEnd,
              ColorName.primaryColor,
            ],
          ),
        ),
        child: Center(
          child: SizedBox(
            height: height != null ? height! / 2 : 27.h,
            width: height != null ? height! / 2 : 27.h,
            child: const CircularProgressIndicator(
              color: Colors.white60,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
      crossFadeState:
          isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vschool/commons/widgets/buttons/secondary_button.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String content;
  final TextAlign contentTextAlign;
  final int imageType;
  final String buttonTitle;
  final VoidCallback? onButtonTap;

  const SuccessDialog({
    super.key,
    this.title = 'Thành công!',
    required this.content,
    this.contentTextAlign = TextAlign.start,
    this.imageType = 0,
    this.buttonTitle = 'Xong',
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            // vertical: 16.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Stack(
            children: [
              imageType == 0
                  ? Positioned(
                      top: -48.h,
                      left: 0,
                      right: 0,
                      child: Lottie.asset(
                        'assets/lottie/success.json',
                        repeat: false,
                        fit: BoxFit.cover,
                        height: 200.h,
                      ),
                    )
                  : Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Lottie.asset(
                        'assets/lottie/fail.json',
                        repeat: false,
                        fit: BoxFit.contain,
                        height: 200.h,
                      ),
                    ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 200.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      content,
                      textAlign: contentTextAlign,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  SizedBox(
                    height: 50.h,
                    width: double.infinity,
                    child: SecondaryButton(
                      onTap: onButtonTap ?? Navigator.of(context).pop,
                      title: buttonTitle,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/widgets/buttons/primary_button.dart';
import 'package:vschool/gen/assets.gen.dart';

class CommonErrorPage extends StatelessWidget {
  final String? message;
  final void Function()? onTap;

  const CommonErrorPage({
    Key? key,
    this.message,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Assets.images.commonError.image(
                fit: BoxFit.cover,
                width: 160.w,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Có lỗi xảy ra!',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Text(
              message ?? 'Vui lòng kiểm tra lại thông tin tìm kiếm',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onTap != null) SizedBox(height: 36.h),
            if (onTap != null)
              SizedBox(
                height: 56.h,
                child: PrimaryButton(
                  title: 'Chạm để tải lại',
                  onTap: onTap,
                ),
              ),
            SizedBox(height: 64.h),
          ],
        ),
      ),
    );
  }
}

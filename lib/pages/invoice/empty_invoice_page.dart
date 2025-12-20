import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vschool/gen/assets.gen.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class EmptyInvoicePage extends StatelessWidget {
  const EmptyInvoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Assets.images.noData.image(
                  fit: BoxFit.cover,
                  width: 160.w,
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'Không có hoá đơn !',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              SizedBox(height: 64.h),
            ],
          ),
        ),
      ),
    );
  }
}

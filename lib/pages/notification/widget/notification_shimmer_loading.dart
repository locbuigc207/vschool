import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/widgets/animations/shimmer_widget.dart';

class NotificationShimmerLoading extends StatelessWidget {
  const NotificationShimmerLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerColor(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 32.h),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => ShimmerWidget(
          height: index < 2 ? 200.h : 80.h,
          width: double.infinity,
        ),
        separatorBuilder: (context, index) => SizedBox(height: 24.h),
        itemCount: 4,
      ),
    );
  }
}

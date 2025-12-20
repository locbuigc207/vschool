import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

class ListMenuButton extends StatelessWidget {
  final ChildrenInfoModel child;

  const ListMenuButton({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dành cho con bạn',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: 'Sarabun',
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            InkWell(
              onTap: () => context.pushRoute(ScheduleRoute(child: child)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                        color: ColorName.linkBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Assets.icons.calender.svg(),
                  ),
                  SizedBox(height: 12.h),
                  const Text(
                    'Lịch học',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => context.pushRoute(ReportCardRoute(child: child)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                        color: ColorName.primaryGradientStart,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Assets.icons.book.svg(),
                  ),
                  SizedBox(height: 12.h),
                  const Text(
                    'Sổ liên lạc',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => context.pushRoute(FoodMenuRoute(child: child)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                        color: ColorName.foam,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Assets.icons.food.svg(),
                  ),
                  SizedBox(height: 12.h),
                  const Text(
                    'Thực đơn',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => context.pushRoute(HeathRoute(child: child)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                        color: ColorName.textMainColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Assets.icons.health.svg(),
                  ),
                  SizedBox(height: 12.h),
                  const Text(
                    'Sức khỏe',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun'),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        const Text(
          'Tiện ích nổi bật',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: 'Sarabun',
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            InkWell(
              onTap: () => context.pushRoute(InvoiceDetailRoute(child: child)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                        color: ColorName.scotchMist,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Assets.icons.money.svg(),
                  ),
                  SizedBox(height: 12.h),
                  const Text(
                    'Thanh toán',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun'),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            InkWell(
              onTap: () => context.pushRoute(InvoiceRoute(childId: child)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                        color: ColorName.borderColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Assets.icons.bill.svg(),
                  ),
                  SizedBox(height: 12.h),
                  const Text(
                    'Hóa đơn',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun'),
                  ),
                ],
              ),
            ),
            SizedBox(width: 22.w),
            InkWell(
              onTap: () => context.pushRoute(AdmissionsRoute(child: child)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 50.w,
                    height: 50.h,
                    decoration: const BoxDecoration(
                        color: ColorName.linkBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Assets.icons.student.svg(),
                  ),
                  SizedBox(height: 12.h),
                  const Text(
                    'Tuyển sinh',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

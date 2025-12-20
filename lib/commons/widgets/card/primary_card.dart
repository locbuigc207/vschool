import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

class PrimaryCard extends StatelessWidget {
  final String content;
  final String studentName;

  const PrimaryCard(
      {Key? key, required this.content, required this.studentName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
          border: Border.all(color: ColorName.borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Assets.icons.aBrown.svg(),
            ],
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Sarabun',
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                studentName,
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Sarabun',
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 10.h),
              const Text(
                'Trân trọng thông báo quý phụ huynh của cháu …',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Sarabun',
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              const Text(
                '21:57 20/02/2023',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ],
      ),
    );
  }
}

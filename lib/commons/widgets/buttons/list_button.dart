import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/widgets/card/shadow_card.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

class ListButton extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final Widget? body;
  final Widget? trailing;
  final void Function()? onTap;

  const ListButton({
    Key? key,
    this.leading,
    this.title,
    this.body,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowCard(
      shadowOpacity: 0.2,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onTap,
          child: SizedBox(
            height: 64.h,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    leading ?? const SizedBox.shrink(),
                    leading != null
                        ? SizedBox(width: 16.w)
                        : const SizedBox.shrink(),
                    Expanded(
                      child: body ??
                          Text(
                            title ?? '',
                            style:
                                Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ColorName.textGray1,
                                    ),
                          ),
                    ),
                    trailing != null
                        ? SizedBox(width: 16.w)
                        : const SizedBox.shrink(),
                    trailing ??
                        Assets.icons.chevronRight.svg(
                          width: 16.r,
                          height: 16.r,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

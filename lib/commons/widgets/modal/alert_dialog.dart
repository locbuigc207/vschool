// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

// Project imports:
typedef Int2VoidFunc = void Function(BuildContext context);

BuildContext? thisContext;

void showAlertDialog(
  BuildContext context, {
  String message = '',
  Widget? widget,
  String title = 'Thông báo',
  callback1,
  callback2,
  barrierDismissible = true,
  bool? isVisible = true,
  String? primaryButtonTitle,
  Int2VoidFunc? onSecondaryButtonTap,
  Int2VoidFunc? onPrimaryButtonTap,
  String? secondaryButtonTitle,
  Widget? content,
}) {
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (dialogContext) {
      thisContext = dialogContext;
      return PopScope(
          canPop: barrierDismissible,
          child: AlertDialog(
              // insetPadding: const EdgeInsets.all(10),
              actionsPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              contentPadding: EdgeInsets.only(
                  top: 20.h, left: 20.w, right: 20.w, bottom: 36.h),
              title: Text(title, textAlign: TextAlign.center),
              content: content ?? Text(message, textAlign: TextAlign.center),
              actions: [
                Row(
                  children: [
                    Visibility(
                      visible: (secondaryButtonTitle ?? '').isNotEmpty
                          ? true
                          : false,
                      child: Expanded(
                        child: SizedBox(
                          height: 50.h,
                          child: SecondaryButton(
                            onTap: () {
                              if (onSecondaryButtonTap != null) {
                                onSecondaryButtonTap(dialogContext);
                              } else {
                                Navigator.of(dialogContext).pop();
                              }
                            },
                            title: secondaryButtonTitle ?? '',
                          ),
                        ),
                      ),
                    ),
                    (secondaryButtonTitle ?? '').isNotEmpty
                        ? SizedBox(width: 20.w)
                        : const SizedBox.shrink(),
                    Expanded(
                      child: SizedBox(
                        height: 50.h,
                        child: PrimaryButton(
                          onTap: () {
                            if (onPrimaryButtonTap != null) {
                              onPrimaryButtonTap(dialogContext);
                            } else {
                              Navigator.of(dialogContext).pop();
                            }
                          },
                          title: primaryButtonTitle ?? '',
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ]));
    },
  );
}

BuildContext? getContext() => thisContext;

/// Convenience helper to show a standard info dialog for features under development
void showFeatureUnderDevelopmentDialog(BuildContext context, {required String featureName}) {
  showAlertDialog(
    context,
    title: 'Thông báo',
    message: 'Tính năng $featureName đang được phát triển!',
    barrierDismissible: true,
    primaryButtonTitle: 'Đóng',
  );
}

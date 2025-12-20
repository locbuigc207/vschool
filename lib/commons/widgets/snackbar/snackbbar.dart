import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vschool/gen/colors.gen.dart';

class SnackBBar extends SnackBar {
  SnackBBar({
    Key? key,
    required BuildContext context,
    Widget? icon,
    required String message,
    String? actionLabel = 'Đóng',
    void Function()? onActionTap,
    Duration duration = const Duration(seconds: 4),
  }) : super(
          key: key,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          behavior: SnackBarBehavior.floating,
          duration: duration,
          dismissDirection: DismissDirection.horizontal,
          content: Row(
            children: [
              icon ?? const SizedBox.shrink(),
              if (icon != null) const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          action: actionLabel != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: ColorName.primaryColor,
                  onPressed: onActionTap ?? () {},
                )
              : null,
        );
}

Future<void> showErrorSnackBBar({
  required BuildContext context,
  required String message,
  String? actionLabel,
  void Function()? onActionTap,
  Duration? duration,
}) async {
  final snackBar = SnackBBar(
    context: context,
    duration: duration ?? const Duration(seconds: 2),
    icon: const Icon(
      CupertinoIcons.exclamationmark_circle,
      color: ColorName.error,
      size: 24.0,
    ),
    message: message,
    actionLabel: actionLabel,
    onActionTap: onActionTap,
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> showSuccessSnackBBar({
  required BuildContext context,
  required String message,
  void Function()? onActionTap,
  String? actionLabel = 'Đóng',
  Duration duration = const Duration(seconds: 2),
}) async {
  final snackBar = SnackBBar(
    context: context,
    duration: duration,
    icon: const Icon(
      CupertinoIcons.checkmark_alt_circle,
      color: ColorName.success,
      size: 24.0,
    ),
    message: message,
    actionLabel: actionLabel,
    onActionTap: onActionTap,
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

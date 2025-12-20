import 'package:flutter/material.dart';
import 'package:vschool/gen/colors.gen.dart';

class ShadowCard extends StatelessWidget {
  final Widget child;
  final double shadowOpacity;
  final double borderRadius;
  final bool hasBorder;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;

  const ShadowCard({
    super.key,
    required this.child,
    this.shadowOpacity = 0.1,
    this.borderRadius = 16.0,
    this.hasBorder = false,
    this.backgroundColor = Colors.white,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: shadowOpacity),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
        border: Border.all(
          color: ColorName.cardBorderColor,
          width: 0.1,
          style: hasBorder ? BorderStyle.solid : BorderStyle.none,
        ),
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';

class RoundedTopContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const RoundedTopContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: child,
    );
  }
}

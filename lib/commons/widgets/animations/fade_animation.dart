import 'package:flutter/material.dart';

enum AniProps { opacity, translateY, translateX }

enum FadeDirection { up, down }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final FadeDirection direction;
  final bool playAnimation;

  const FadeAnimation({
    Key? key,
    required this.delay,
    required this.child,
    this.direction = FadeDirection.down,
    AssetImage? image,
    this.playAnimation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!playAnimation) return child;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: (500 * delay).round() + 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              (1 - value) * (direction == FadeDirection.down ? -30.0 : 30.0),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

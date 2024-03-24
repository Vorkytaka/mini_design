import 'package:flutter/material.dart';

/// Widget that translate it's child to an [jumpOffset] and backward.
class AnimatedJumperWidget extends StatelessWidget {
  final Animation<double> animation;
  final Offset jumpOffset;
  final Widget child;

  const AnimatedJumperWidget({
    required this.animation,
    required this.jumpOffset,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = 1 - (animation.value - 0.5).abs() * 2;
        final offset = Offset.lerp(Offset.zero, jumpOffset, t)!;

        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: child,
    );
  }
}

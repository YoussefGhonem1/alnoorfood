import 'package:flutter/material.dart';

class IconFadeAnimation extends StatelessWidget {
  final Widget child;
  const IconFadeAnimation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: child);
  }
}

import 'package:flutter/material.dart';

class AuthScreenAnimation extends Page {
  final Widget child;
  final bool isForward;

  const AuthScreenAnimation({
    required this.child,
    required this.isForward,
    required LocalKey key,
  }) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin =
            isForward
                ? const Offset(1.0, 0.0) 
                : const Offset(-1.0, 0.0);
        const end = Offset.zero;

        final curve = CurveTween(curve: Curves.easeOutCubic);
        final tween = Tween(begin: begin, end: end).chain(curve);
        final offsetAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<dynamic> fadeScaleDialogPage(
  GoRouterState state,
  Widget childWidget,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    fullscreenDialog: true,
    maintainState: true,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: child,
        ),
      );
    },
    child: childWidget,
  );
}

int calculateSelectedIndex(String location) {
  if (location.startsWith('/upload')) {
    return 1;
  }
  if (location.startsWith('/map')) {
    return 2;
  }
  if (location.startsWith('/setting')) {
    return 3;
  }
  return 0;
}


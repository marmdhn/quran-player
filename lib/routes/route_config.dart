import 'package:flutter/material.dart';

enum AppTransition { fade, slideRight, slideUp, scale }

class RouteConfig {
  final Widget page;
  final AppTransition transition;

  const RouteConfig({
    required this.page,
    this.transition = AppTransition.slideRight,
  });

  Route<dynamic> buildRoute() {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        switch (transition) {
          case AppTransition.fade:
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
                child: child,
              ),
            );
          case AppTransition.scale:
            return ScaleTransition(scale: curved, child: child);
          case AppTransition.slideUp:
            return SlideTransition(
              position: Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            );
          case AppTransition.slideRight:
            return SlideTransition(
              position: Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            );
        }
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

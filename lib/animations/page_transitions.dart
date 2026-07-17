import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/ui_constants.dart';

CustomTransitionPage slideUpRoute(Widget page) {
  return CustomTransitionPage(
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: const Offset(0, 0.25),
        end: Offset.zero,
      );
      final fadeTween = Tween<double>(begin: 0, end: 1);

      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
        ),
        child: FadeTransition(
          opacity: fadeTween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          ),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(
      milliseconds: UiConstants.slideDuration,
    ),
  );
}

CustomTransitionPage slideDownRoute(Widget page) {
  return CustomTransitionPage(
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, 0.25),
      );
      final fadeTween = Tween<double>(begin: 1, end: 0);

      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
        ),
        child: FadeTransition(
          opacity: fadeTween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          ),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(
      milliseconds: UiConstants.slideDuration,
    ),
  );
}

CustomTransitionPage scaleRoute(Widget page) {
  return CustomTransitionPage(
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scaleTween = Tween<double>(begin: 0.8, end: 1);
      final fadeTween = Tween<double>(begin: 0, end: 1);

      return ScaleTransition(
        scale: scaleTween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
        ),
        child: FadeTransition(
          opacity: fadeTween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          ),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(
      milliseconds: UiConstants.fadeDuration,
    ),
  );
}

CustomTransitionPage fadeRoute(Widget page) {
  return CustomTransitionPage(
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(
      milliseconds: UiConstants.fadeDuration,
    ),
  );
}

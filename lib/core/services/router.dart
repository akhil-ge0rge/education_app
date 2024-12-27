import 'package:education_app/core/common/view/page_under_construction_screen.dart';
import 'package:education_app/src/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnboardingScreen.routeName:
      return _pageBuilder((_) => const OnboardingScreen(), settings: settings);
    default:
      return _pageBuilder(
        (_) => const PageUnderConstructionScreen(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext context) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}

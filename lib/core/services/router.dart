import 'package:education_app/core/common/view/page_under_construction_screen.dart';
import 'package:education_app/core/extension/context_extension.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/auth/presentation/view/sign_in_screen.dart';
import 'package:education_app/src/auth/presentation/view/sign_up_screen.dart';
import 'package:education_app/src/dashboard/presentation/view/dashboard.dart';
import 'package:education_app/src/onboarding/data/datasources/onboarding_local_datasources.dart';
import 'package:education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:education_app/src/onboarding/presentation/views/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final pref = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (pref.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (context) => sl<OnboardingCubit>(),
              child: const OnboardingScreen(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = LocalUserModel(
              uid: user.uid,
              fullName: user.displayName ?? '',
              email: user.email ?? '',
              points: 0,
            );
            context.userProvider.initUser(localUser);
            return const DashboardScreen();
          }
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignInScreen(),
          );
        },
        settings: settings,
      );
    case SignInScreen.routeName:
      return _pageBuilder(
        (context) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case SignUpScreen.routeName:
      return _pageBuilder(
        (context) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case DashboardScreen.routeName:
      return _pageBuilder((_) => const DashboardScreen(), settings: settings);
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

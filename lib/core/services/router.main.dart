part of 'router.dart';

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
    case '/forgot-password':
      return _pageBuilder(
        (_) => const fui.ForgotPasswordScreen(),
        settings: settings,
      );
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

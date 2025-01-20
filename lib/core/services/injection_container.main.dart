part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnboarding();
  await _initAuth();
}

Future<void> _initOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  //OnBoardingFeature
  sl
    ..registerFactory(
      () => OnboardingCubit(
        cacheFirstTimer: sl(),
        checkingIsUserFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepoImpl(sl()),
    )
    ..registerLazySingleton<OnboardingLocalDatasources>(
      () => OnboardingLocalDatasourcesImpl(sl()),
    )
    ..registerLazySingleton(() => prefs);
}

Future<void> _initAuth() async {
  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDatasources>(
      () => AuthRemoteDatasourcesImpl(
        authClient: sl(),
        cloudStorageClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

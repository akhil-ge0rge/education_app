import 'package:education_app/src/onboarding/data/repos/onboarding_repo_impl.dart';
import 'package:education_app/src/onboarding/domain/usecase/cache_first_timer.dart';
import 'package:education_app/src/onboarding/domain/usecase/check_if_user_is_first_timer.dart';
import 'package:education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/onboarding/data/datasources/onboarding_local_datasources.dart';
import '../../src/onboarding/domain/repositories/onboarding_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  //OnBoardingFeature
  sl
    ..registerFactory(
      () => OnboardingCubit(
        cacheFirstTimer: sl(),
        checkingIsUserFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(
      () => CacheFirstTimer(sl()),
    )
    ..registerLazySingleton(
      () => CheckIfUserIsFirstTimer(
        sl(),
      ),
    )
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepoImpl(sl()),
    )
    ..registerLazySingleton<OnboardingLocalDatasources>(
      () => OnboardingLocalDatasourcesImpl(sl()),
    )
    ..registerLazySingleton(
      () => prefs,
    );
}

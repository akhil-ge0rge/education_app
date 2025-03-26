import 'package:bloc/bloc.dart';
import 'package:education_app/src/onboarding/domain/usecase/cache_first_timer.dart';
import 'package:education_app/src/onboarding/domain/usecase/check_if_user_is_first_timer.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required CacheFirstTimer cacheFirstTimer,
    required CheckIfUserIsFirstTimer checkingIsUserFirstTimer,
  })  : _cacheFirstTimer = cacheFirstTimer,
        _checkingIsUserFirstTimer = checkingIsUserFirstTimer,
        super(const OnboardingInitial());

  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserIsFirstTimer _checkingIsUserFirstTimer;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimer());
    final result = await _cacheFirstTimer();
    result.fold(
      (l) => emit(OnBoardingError(message: l.errorMessage)),
      (r) => emit(const UserCached()),
    );
  }

  Future<void> checkingIsUserFirstTimer() async {
    emit(const CheckingIsUserFirstTimer());
    final result = await _checkingIsUserFirstTimer();
    result.fold(
      (l) => emit(const OnBoardingStatus(isFirstTimer: true)),
      (r) => emit(OnBoardingStatus(isFirstTimer: r)),
    );
  }
}

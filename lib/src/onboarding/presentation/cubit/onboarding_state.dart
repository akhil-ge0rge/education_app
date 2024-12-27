part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class CachingFirstTimer extends OnboardingState {
  const CachingFirstTimer();
}

final class CheckingIsUserFirstTimer extends OnboardingState {
  const CheckingIsUserFirstTimer();
}

final class UserCached extends OnboardingState {
  const UserCached();
}

final class OnBoardingStatus extends OnboardingState {
  const OnBoardingStatus({required this.isFirstTimer});
  final bool isFirstTimer;
  @override
  List<bool> get props => [isFirstTimer];
}

final class OnBoardingError extends OnboardingState {
  const OnBoardingError({required this.message});
  final String message;
  @override
  List<String> get props => [message];
}

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/onboarding/domain/usecase/cache_first_timer.dart';
import 'package:education_app/src/onboarding/domain/usecase/check_if_user_is_first_timer.dart';
import 'package:education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnboardingCubit cubit;

  setUp(
    () {
      cacheFirstTimer = MockCacheFirstTimer();
      checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
      cubit = OnboardingCubit(
        cacheFirstTimer: cacheFirstTimer,
        checkingIsUserFirstTimer: checkIfUserIsFirstTimer,
      );
    },
  );
  final tFailure = CacheFailure(
    message: 'Insuficent Storage Permission',
    statusCode: 403,
  );
  test(
    'initial state should be [OnboardingInitial]',
    () {
      expect(cubit.state, const OnboardingInitial());
    },
  );
  group(
    'chacheFirstTimer',
    () {
      blocTest<OnboardingCubit, OnboardingState>(
        'should emit [CachingFirstTimer , UserCached] '
        'when sucessful ',
        build: () {
          when(
            () => cacheFirstTimer(),
          ).thenAnswer(
            (invocation) async => const Right(null),
          );
          return cubit;
        },
        act: (bloc) => cubit.cacheFirstTimer(),
        expect: () => const [
          CachingFirstTimer(),
          UserCached(),
        ],
        verify: (_) {
          verify(() => cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'should emit a [CachingFirstTimer,OnbardingError] on unsucessful',
        build: () {
          when(
            () => cacheFirstTimer(),
          ).thenAnswer(
            (invocation) async => Left(
              tFailure,
            ),
          );
          return cubit;
        },
        act: (bloc) => bloc.cacheFirstTimer(),
        expect: () => [
          const CachingFirstTimer(),
          OnBoardingError(message: tFailure.errorMessage),
        ],
        verify: (_) {
          verify(
            () => cacheFirstTimer(),
          ).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );
    },
  );

  group(
    'checkIsTheUserIsFirstTimer',
    () {
      blocTest<OnboardingCubit, OnboardingState>(
        'should emit [CheckingIfUserIsFirstTimer,OnBoardingStatus] '
        'when sucessful',
        build: () {
          when(
            () => checkIfUserIsFirstTimer(),
          ).thenAnswer(
            (_) async => const Right(false),
          );
          return cubit;
        },
        act: (bloc) => bloc.checkingIsUserFirstTimer(),
        expect: () => const [
          CheckingIsUserFirstTimer(),
          OnBoardingStatus(isFirstTimer: false),
        ],
        verify: (_) {
          verify(
            () => checkIfUserIsFirstTimer(),
          ).called(1);
          verifyNoMoreInteractions(checkIfUserIsFirstTimer);
        },
      );
      blocTest<OnboardingCubit, OnboardingState>(
        'should emit [CheckingIfUserIsFirstTimer,OnBoardingStatus(true)] '
        'when unsucessful',
        build: () {
          when(
            () => checkIfUserIsFirstTimer(),
          ).thenAnswer(
            (_) async => Left(tFailure),
          );
          return cubit;
        },
        act: (bloc) => bloc.checkingIsUserFirstTimer(),
        expect: () => const [
          CheckingIsUserFirstTimer(),
          OnBoardingStatus(isFirstTimer: true),
        ],
        verify: (_) {
          verify(
            () => checkIfUserIsFirstTimer(),
          ).called(1);
          verifyNoMoreInteractions(checkIfUserIsFirstTimer);
        },
      );
    },
  );
}

import 'package:dartz/dartz.dart';
import 'package:education_app/src/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:education_app/src/onboarding/domain/usecase/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'onboarding_repo.mock.dart';

void main() {
  late OnboardingRepository repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    repo = MockOnboardingRepo();
    usecase = CheckIfUserIsFirstTimer(repo);
  });

  test(
    'should call [OnBoardingRepo.checkIfUserIsFirstTimer] '
    'and return right answer',
    () async {
      when(
        () => repo.checkIfUserIsFirstTimer(),
      ).thenAnswer(
        (invocation) async => const Right(true),
      );
      final result = await usecase();
      expect(
        result,
        equals(
          const Right<dynamic, bool>(true),
        ),
      );
      verify(
        () => repo.checkIfUserIsFirstTimer(),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}

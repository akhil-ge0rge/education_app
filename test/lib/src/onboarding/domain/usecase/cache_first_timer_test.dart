import 'package:dartz/dartz.dart';
import 'package:education_app/src/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:education_app/src/onboarding/domain/usecase/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'onboarding_repo.mock.dart';

void main() {
  late OnboardingRepository repo;
  late CacheFirstTimer cacheFirstTimer;

  setUp(() {
    repo = MockOnboardingRepo();
    cacheFirstTimer = CacheFirstTimer(repo);
  });

  test(
    'should call [OnBoardingRepo.cacheFirstTimer] '
    'and return right answer',
    () async {
      when(
        () => repo.cacheFirstTimer(),
      ).thenAnswer(
        (invocation) async => const Right(null),
      );
    },
  );
}

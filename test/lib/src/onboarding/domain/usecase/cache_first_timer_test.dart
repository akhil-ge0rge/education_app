import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:education_app/src/onboarding/domain/usecase/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'onboarding_repo.mock.dart';

void main() {
  late OnboardingRepository repo;
  late CacheFirstTimer usecase;

  setUp(() {
    repo = MockOnboardingRepo();
    usecase = CacheFirstTimer(repo);
  });

  test(
    'should call [OnBoardingRepo.cacheFirstTimer] '
    'and return right answer',
    () async {
      when(
        () => repo.cacheFirstTimer(),
      ).thenAnswer(
        (invocation) async => Left(
          ServerFailure(
            message: 'Unknown Error Occoured',
            statusCode: 500,
          ),
        ),
      );
      final result = await usecase();
      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: 'Unknown Error Occoured',
              statusCode: 500,
            ),
          ),
        ),
      );
      verify(
        () => repo.cacheFirstTimer(),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}

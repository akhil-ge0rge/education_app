import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/onboarding/data/datasources/onboarding_local_datasources.dart';
import 'package:education_app/src/onboarding/data/repos/onboarding_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingLocalDataSrc extends Mock
    implements OnboardingLocalDatasources {}

void main() {
  late OnboardingLocalDatasources localDataSrc;
  late OnboardingRepoImpl repoImpl;
  setUp(
    () {
      localDataSrc = MockOnboardingLocalDataSrc();
      repoImpl = OnboardingRepoImpl(localDataSrc);
    },
  );

  test('should be a subclass of [OnboardingRepo]', () {
    expect(repoImpl, isA<OnboardingRepoImpl>());
  });

  group(
    'cacheFirstTimer',
    () {
      test(
        'should complete sucessfuly when call to local source is sucessful',
        () async {
          when(
            () => localDataSrc.cacheFirstTimer(),
          ).thenAnswer(
            (_) async => Future.value(),
          );

          final result = await repoImpl.cacheFirstTimer();

          expect(result, equals(const Right<dynamic, void>(null)));
          verify(
            () => localDataSrc.cacheFirstTimer(),
          ).called(1);
          verifyNoMoreInteractions(localDataSrc);
        },
      );

      test(
        'should return [CacheFailure] when call local source is unsuccessful',
        () async {
          when(() => localDataSrc.cacheFirstTimer())
              .thenThrow(const CacheException(message: 'Insuficent Storage'));

          final result = await repoImpl.cacheFirstTimer();

          expect(
            result,
            equals(
              Left<CacheFailure, dynamic>(
                CacheFailure(
                  message: 'Insuficent Storage',
                  statusCode: 500,
                ),
              ),
            ),
          );
          verify(
            () => localDataSrc.cacheFirstTimer(),
          ).called(1);
          verifyNoMoreInteractions(localDataSrc);
        },
      );
    },
  );
}

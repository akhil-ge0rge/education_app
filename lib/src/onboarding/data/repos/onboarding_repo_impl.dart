import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/onboarding/data/datasources/onboarding_local_datasources.dart';
import 'package:education_app/src/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepoImpl implements OnboardingRepository {
  OnboardingRepoImpl(this._localDataSource);
  final OnboardingLocalDatasources _localDataSource;

  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      await _localDataSource.cacheFirstTimer();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTimer() async {
    try {
      final res = await _localDataSource.checkIfUserIsFirstTimer();
      return Right(res);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}

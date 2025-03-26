import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/onboarding/domain/repositories/onboarding_repository.dart';

class CacheFirstTimer extends UseCaseWithOutParams<void> {
  const CacheFirstTimer(this._repo);

  final OnboardingRepository _repo;
  @override
  ResultFuture<void> call() async => _repo.cacheFirstTimer();
}

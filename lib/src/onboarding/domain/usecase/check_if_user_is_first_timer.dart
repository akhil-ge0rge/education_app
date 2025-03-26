import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/onboarding/domain/repositories/onboarding_repository.dart';

class CheckIfUserIsFirstTimer extends UseCaseWithOutParams<bool> {
  CheckIfUserIsFirstTimer(this._repo);
  final OnboardingRepository _repo;
  @override
  ResultFuture<bool> call() async => _repo.checkIfUserIsFirstTimer();
}

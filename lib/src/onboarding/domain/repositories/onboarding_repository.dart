import 'package:education_app/core/utils/typedef.dart';

abstract class OnboardingRepository {
  ResultFuture<void> cacheFirstTimer();
  ResultFuture<bool> checkIfUserIsFirstTimer();
}

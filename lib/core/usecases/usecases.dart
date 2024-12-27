import 'package:education_app/core/utils/typedef.dart';

abstract class UseCaseWithParams<Type, Params> {
  const UseCaseWithParams();

  ResultFuture<Type> call(Params arams);
}

abstract class UseCaseWithOutParams<Type> {
  const UseCaseWithOutParams();

  ResultFuture<Type> call();
}

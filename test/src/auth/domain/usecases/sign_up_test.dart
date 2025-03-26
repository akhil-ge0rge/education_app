import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignUp usecase;
  const tEmail = 'email';
  const tPassword = 'pass';
  const tFullname = 'name';
  setUp(
    () {
      repo = MockAuthRepo();
      usecase = SignUp(repo);
    },
  );

  test(
    'should call [AuthRepo]',
    () async {
      when(
        () => repo.signUp(
          email: any(named: 'email'),
          fullName: any(named: 'fullName'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const SignUpParams(
          email: tEmail,
          fullName: tFullname,
          password: tPassword,
        ),
      );

      expect(result, const Right<dynamic, void>(null));
      verify(
        () => repo.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullname,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}

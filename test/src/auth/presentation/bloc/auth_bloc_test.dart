import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();
  const tSignInParams = SignInParams.empty();
  final tServerFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
    );
  });
  setUpAll(() {
    registerFallbackValue(tUpdateUserParams);
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
  });

  tearDown(() => authBloc.close());

  test(
    'initialState should be [AuthInitial]',
    () {
      expect(authBloc.state, const AuthInitial());
    },
  );

  group(
    'SignInEvent',
    () {
      const tUser = LocalUserModel.empty();
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, Signed In] when '
        '[SignInEvent] is succeed',
        build: () {
          when(
            () => signIn(any()),
          ).thenAnswer(
            (_) async => const Right(tUser),
          );

          return authBloc;
        },
        act: (bloc) => bloc.add(
          SignInEvent(
            email: tSignInParams.email,
            password: tSignInParams.password,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const SignedIn(user: tUser),
        ],
        verify: (_) {
          verify(
            () => signIn(
              SignInParams(
                email: tSignInParams.email,
                password: tSignInParams.password,
              ),
            ),
          ).called(1);
          verifyNoMoreInteractions(signIn);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when signIn fails',
        build: () {
          when(
            () => signIn(any()),
          ).thenAnswer((invocation) async => Left(tServerFailure));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          SignInEvent(
            email: tSignInParams.email,
            password: tSignInParams.password,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          AuthError(message: tServerFailure.errorMessage),
        ],
        verify: (_) {
          verify(
            () => signIn(tSignInParams),
          ).called(1);
          verifyNoMoreInteractions(signIn);
        },
      );
    },
  );

  group(
    'SignUpEvent',
    () {
      blocTest<AuthBloc, AuthState>(
        'should return [AuthLoading, AuthSignedUp] '
        ' when SignUpEvent Added and SignUp Succeed',
        build: () {
          when(() => signUp(any())).thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            name: tSignUpParams.fullName,
            password: tSignUpParams.password,
          ),
        ),
        expect: () => const [AuthLoading(), SignedUp()],
        verify: (_) {
          verify(
            () => signUp(tSignUpParams),
          ).called(1);
          verifyNoMoreInteractions(signUp);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should return [AuthLoading,AuthError] '
        'when SignUpEvent added and fails',
        build: () {
          when(() => signUp(any()))
              .thenAnswer((_) async => Left(tServerFailure));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            name: tSignUpParams.fullName,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          AuthError(message: tServerFailure.errorMessage),
        ],
        verify: (_) {
          verify(() => signUp(tSignUpParams)).called(1);
          verifyNoMoreInteractions(signUp);
        },
      );
    },
  );

  group(
    'ForgotPasswordEvent',
    () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading,ForgotPasswordSent] when ForgotPassWordEvent '
        'is added and ForgotPassword succeeds',
        build: () {
          when(() => forgotPassword(any()))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const ForgotPasswordEvent(email: 'email')),
        expect: () => const [AuthLoading(), ForgotPasswordSend()],
        verify: (_) {
          verify(
            () => forgotPassword('email'),
          ).called(1);
          verifyNoMoreInteractions(forgotPassword);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading,AuthError] when ForgotPasswordEvent '
        'is added and ForgotPassword Fails',
        build: () {
          when(() => forgotPassword(any())).thenAnswer(
            (_) async => Left(tServerFailure),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(const ForgotPasswordEvent(email: 'email')),
        expect: () => [
          const AuthLoading(),
          AuthError(message: tServerFailure.errorMessage),
        ],
      );
    },
  );

  group(
    'UpdateUser',
    () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading,UserUpdated] when UserUpdateEvent is added '
        'and UpdateEvent Succeed',
        build: () {
          when(
            () => updateUser(tUpdateUserParams),
          ).thenAnswer(
            (_) async => const Right(null),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          UpdateUserEvent(
            action: tUpdateUserParams.action,
            userData: tUpdateUserParams.userData,
          ),
        ),
        expect: () => const [AuthLoading(), UserUpdated()],
        verify: (_) {
          verify(() => updateUser(tUpdateUserParams)).called(1);
          verifyNoMoreInteractions(updateUser);
        },
      );
    },
  );
}

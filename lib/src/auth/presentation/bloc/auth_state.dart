part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class SignedIn extends AuthState {
  const SignedIn({required this.user});
  final LocalUser user;

  @override
  List<Object> get props => [user];
}

final class SignedUp extends AuthState {
  const SignedUp();
}

final class ForgotPasswordSend extends AuthState {
  const ForgotPasswordSend();
}

final class UserUpdated extends AuthState {
  const UserUpdated();
}

final class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;
  @override
  List<String> get props => [message];
}

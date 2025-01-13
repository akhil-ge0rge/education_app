import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';

abstract class AuthRemoteDatasources {
  const AuthRemoteDatasources();
  Future<void> forgotPassword({
    required String email,
  });

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}

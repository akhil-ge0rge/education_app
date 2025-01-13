import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class AuthRemoteDatasourcesImpl implements AuthRemoteDatasources {
  AuthRemoteDatasourcesImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStorageClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStorageClient = cloudStorageClient,
        _dbClient = dbClient;
  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStorageClient;
  final FirebaseStorage _dbClient;
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasources.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test Uid';
  @override
  String get uid => _uid;
  set uid(String value) {
    if (_uid != value) {
      _uid = value;
    }
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;
  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) {
      _user = value;
    }
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStorageClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDatasources datasources;
  late UserCredential userCredential;
  late DocumentReference<DataMap> documentReference;
  late MockUser mockUser;
  const tUser = LocalUserModel.empty();

  setUpAll(
    () async {
      authClient = MockFirebaseAuth();
      cloudStorageClient = FakeFirebaseFirestore();
      dbClient = MockFirebaseStorage();
      documentReference = cloudStorageClient.collection('users').doc();
      await documentReference.set(
        tUser.copyWith(uid: documentReference.id).toMap(),
      );
      mockUser = MockUser().._uid = documentReference.id;
      userCredential = MockUserCredential(mockUser);
      datasources = AuthRemoteDatasourcesImpl(
        authClient: authClient,
        cloudStorageClient: cloudStorageClient,
        dbClient: dbClient,
      );
      when(() => authClient.currentUser).thenReturn(mockUser);
    },
  );
  const tPassword = 'Test Password';
  const tFullName = 'Test full name';
  const tEmail = 'Test Email';
  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record corresponding to this identifires',
  );

  group(
    'forgotPassword',
    () {
      test(
        'should complete sucessfullt when no [Exception] is thrown',
        () async {
          when(
            () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
          ).thenAnswer((_) async => Future.value());
          final call = datasources.forgotPassword(email: tEmail);

          expect(call, completes);

          verify(() => authClient.sendPasswordResetEmail(email: tEmail))
              .called(1);
          verifyNoMoreInteractions(authClient);
        },
      );
      test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () {
          when(
            () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
          ).thenThrow(tFirebaseAuthException);
          final call = datasources.forgotPassword;
          expect(() => call(email: tEmail), throwsA(isA<ServerException>()));
          verify(
            () => authClient.sendPasswordResetEmail(email: tEmail),
          ).called(1);
          verifyNoMoreInteractions(authClient);
        },
      );
    },
  );

  group(
    'signIn',
    () {
      test(
        'should return [LocalUserModel] when no [Exception] is thrown',
        () async {
          when(
            () => authClient.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => userCredential,
          );
          final result = await datasources.signIn(
            email: tEmail,
            password: tPassword,
          );
          expect(result.uid, userCredential.user!.uid);
          expect(result.points, 0);
          verify(
            () => authClient.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
          verifyNoMoreInteractions(authClient);
        },
      );
      test(
        'should throw [ServerException] when user is null after signin',
        () async {
          final emptyUserCredential = MockUserCredential();
          when(
            () => authClient.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => emptyUserCredential);

          final call = datasources.signIn;
          expect(
            () => call(email: tEmail, password: tPassword),
            throwsA(isA<ServerException>()),
          );
          verify(
            () => authClient.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
          verifyNoMoreInteractions(authClient);
        },
      );
      test(
        'should return [ServerException] when [FirebaseAuthException] is '
        'thrown',
        () async {
          when(
            () => authClient.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(
            tFirebaseAuthException,
          );
          final call = datasources.signIn;
          expect(
            () => call(email: tEmail, password: tPassword),
            throwsA(isA<ServerException>()),
          );
          verify(
            () => authClient.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
          verifyNoMoreInteractions(authClient);
        },
      );
    },
  );

  group(
    'signUp',
    () {
      test(
        'should complete sucessfully when no [Exception] is thrown',
        () async {
          when(
            () => authClient.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => userCredential,
          );
          //Update Display Name and Photo Url is a part of signUp

          when(
            () => userCredential.user?.updateDisplayName(any()),
          ).thenAnswer(
            (_) async => Future.value(),
          );
          when(
            () => userCredential.user?.updatePhotoURL(any()),
          ).thenAnswer(
            (_) async => Future.value(),
          );

          final call = datasources.signUp(
            email: tEmail,
            fullName: tFullName,
            password: tPassword,
          );
          expect(call, completes);
          verify(
            () => authClient.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
          await untilCalled(
            () => userCredential.user?.updateDisplayName(any()),
          );
          await untilCalled(
            () => userCredential.user?.updatePhotoURL(any()),
          );
          verify(
            () => userCredential.user?.updateDisplayName(tFullName),
          ).called(1);
          verify(
            () => userCredential.user?.updatePhotoURL(kDefaultAvatar),
          ).called(1);

          verifyNoMoreInteractions(authClient);
        },
      );
      test(
        'should throw a [ServerException] when [FirebaseAuthException] '
        'is thrown',
        () async {
          when(
            () => authClient.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(tFirebaseAuthException);

          final call = datasources.signUp;

          expect(
            () => call(
              email: tEmail,
              fullName: tFullName,
              password: tPassword,
            ),
            throwsA(isA<ServerException>()),
          );

          verify(
            () => authClient.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'updateUser',
    () {
      setUp(() {
        registerFallbackValue(MockAuthCredential());
      });

      test(
        'should update user displayName sucessfully when no [Exception] is '
        'thrown',
        () async {
          when(
            () => mockUser.updateDisplayName(any()),
          ).thenAnswer(
            (_) => Future.value(),
          );

          await datasources.updateUser(
            action: UpdateUserAction.displayName,
            userData: tFullName,
          );

          verify(
            () => mockUser.updateDisplayName(tFullName),
          ).called(1);
          verifyNever(() => mockUser.updateEmail(any()));
          verifyNever(() => mockUser.updatePhotoURL(any()));
          verifyNever(() => mockUser.updatePassword(any()));

          final userData = await cloudStorageClient
              .collection('users')
              .doc(mockUser.uid)
              .get();
          expect(userData.data()!['fullName'], tFullName);
        },
      );

      test(
        'should update user bio sucessfully when no [Exception] is '
        'thrown',
        () async {
          const newBio = 'new bio';

          await datasources.updateUser(
            action: UpdateUserAction.bio,
            userData: newBio,
          );

          final userData = await cloudStorageClient
              .collection('users')
              .doc(documentReference.id)
              .get();
          expect(userData.data()!['bio'], newBio);
          verifyNever(() => mockUser.updateDisplayName(any()));
          verifyNever(() => mockUser.updateEmail(any()));
          verifyNever(() => mockUser.updatePhotoURL(any()));
          verifyNever(() => mockUser.updatePassword(any()));
        },
      );

      test(
        'should update user email sucessfully when no [Exception] is '
        'thrown',
        () async {
          when(
            () => mockUser.updateEmail(any()),
          ).thenAnswer(
            (_) async => Future.value(),
          );

          await datasources.updateUser(
            action: UpdateUserAction.email,
            userData: tEmail,
          );

          verify(
            () => mockUser.updateEmail(tEmail),
          ).called(1);

          verifyNever(() => mockUser.updateDisplayName(any()));
          verifyNever(() => mockUser.updatePassword(any()));
          verifyNever(() => mockUser.updatePhotoURL(any()));

          final user = await cloudStorageClient
              .collection('users')
              .doc(mockUser.uid)
              .get();
          expect(user.data()!['email'], tEmail);
        },
      );

      test(
        'should update user password sucessfully when no [Exception] '
        'is thrown',
        () async {
          when(() => mockUser.updatePassword(any()))
              .thenAnswer((_) async => Future.value());

          when(() => mockUser.reauthenticateWithCredential(any())).thenAnswer(
            (_) async => userCredential,
          );

          when(
            () => mockUser.email,
          ).thenReturn(tEmail);

          await datasources.updateUser(
            action: UpdateUserAction.password,
            userData: jsonEncode({
              'oldPassword': 'oldPassword',
              'newPassword': tPassword,
            }),
          );
          verify(() => mockUser.updatePassword(tPassword));

          verifyNever(() => mockUser.updateDisplayName(any()));
          verifyNever(() => mockUser.updateEmail(any()));
          verifyNever(() => mockUser.updatePhotoURL(any()));

          final userData = await cloudStorageClient
              .collection('users')
              .doc(documentReference.id)
              .get();
          expect(userData.data()!['password'], null);
        },
      );

      test(
        'should update user profilePic sucessfully when no [Exception] '
        'is thrown',
        () async {
          final newProfilePic = File('assets/images/onBoarding_background.png');
          when(() => mockUser.updatePhotoURL(any()))
              .thenAnswer((invocation) async => Future.value());
          await datasources.updateUser(
            action: UpdateUserAction.profilePic,
            userData: newProfilePic,
          );
          verify(() => mockUser.updatePhotoURL(any())).called(1);

          verifyNever(() => mockUser.updateDisplayName(any()));
          verifyNever(() => mockUser.updateEmail(any()));
          verifyNever(() => mockUser.updatePassword(any()));

          expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
        },
      );
    },
  );
}

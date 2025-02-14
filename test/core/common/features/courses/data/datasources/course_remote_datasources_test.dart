import 'package:education_app/core/common/features/courses/data/datasources/course_remote_datasources.dart';
import 'package:education_app/core/common/features/courses/data/model/course_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;
  late FakeFirebaseFirestore firestore;
  late CourseRemoteDatasources remoteDatasources;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );
    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);

    storage = MockFirebaseStorage();

    remoteDatasources = CourseRemoteDatasourcesImpl(
      firestore: firestore,
      storage: storage,
      auth: auth,
    );
  });

  group('addCourse', () {
    test(
      'should add the given course to the firestore collection',
      () async {
        final course = CourseModel.empty();

        await remoteDatasources.addCourse(course);

        final firestoreData = await firestore.collection('courses').get();
        expect(firestoreData.docs.length, 1);

        final courseRef = firestoreData.docs.first;
        expect(courseRef.data()['id'], courseRef.id);

        final groupData = await firestore.collection('groups').get();
        expect(groupData.docs.length, 1);

        final groupRef = groupData.docs.first;
        expect(groupRef.data()['id'], groupRef.id);

        expect(courseRef.data()['groupId'], groupRef.id);
        expect(groupRef.data()['courseId'], courseRef.id);
      },
    );
  });

  group('getCourses', () {
    test(
      'should return a List<Course> when the call is successful',
      () async {
        final firstDate = DateTime.now();
        final secondDate = DateTime.now().add(const Duration(seconds: 20));

        final expectedCourse = [
          CourseModel.empty().copyWith(createdAt: firstDate),
          CourseModel.empty().copyWith(
            createdAt: secondDate,
            id: '1',
            title: 'Course 1',
          ),
        ];

        for (final course in expectedCourse) {}
        final result = await remoteDatasources.getCourse();

        expect(result, expectedCourse);
      },
    );
  });
}

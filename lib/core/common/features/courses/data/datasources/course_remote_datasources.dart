import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/courses/data/model/course_model.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class CourseRemoteDatasources {
  Future<List<CourseModel>> getCourse();
  Future<void> addCourse(Course course);
}

class CourseRemoteDatasourcesImpl implements CourseRemoteDatasources {
  CourseRemoteDatasourcesImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _storage = storage,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  @override
  Future<void> addCourse(Course course) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'user is not authenticated',
          statusCode: 401,
        );
      }

      final courseRef = _firestore.collection('courses').doc();
      final groupRef = _firestore.collection('groups').doc();
      var courseModel = (course as CourseModel).copyWith(
        id: courseRef.id,
        groupId: groupRef.id,
      );

      ///courseCreation

      if (courseModel.imageIsFile) {
        final imageRef = _storage.ref().child(
              'courses/${courseModel.id}/profile_image/${courseModel.title}-pfp',
            );
        await imageRef.putFile(File(courseModel.image!)).then(
          (value) async {
            final url = await value.ref.getDownloadURL();
            courseModel.copyWith(image: url);
          },
        );
      }

      await courseRef.set(courseModel.toMap());

//groupCreation
      final group = GroupModel(
        id: groupRef.id,
        name: course.title,
        courseId: courseRef.id,
        members: const [],
        groupImageUrl: courseModel.image,
      );

      return groupRef.set(group.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown Error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<CourseModel>> getCourse() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'user is not authenticated',
          statusCode: 401,
        );
      }
      return _firestore.collection('courses').get().then(
            (value) => value.docs
                .map((doc) => CourseModel.fromMap(doc.data()))
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown Error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}

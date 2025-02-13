import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/courses/data/model/course_model.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixture/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1677483548,
    '_nanoseconds': 123456000,
  };
  final date =
      DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!).add(
    Duration(microseconds: timestampData['_nanoseconds']!),
  );
  final timestamp = Timestamp.fromDate(date);
  final tCourseModel = CourseModel.empty();
  final tMap = jsonDecode(fixture('course.json')) as DataMap;
  tMap['createdAt'] = timestamp;
  tMap['updatedAt'] = timestamp;
  test(
    'should be a subsclass of [Course] entity',
    () {
      expect(tCourseModel, isA<Course>());
    },
  );
  group('empty', () {
    test('should return a [CourseModel] with empty data', () {
      final res = CourseModel.empty();
      expect(res.title, '_empty.title');
    });
  });

  group('fromMap', () {
    test('should return a [CourseModel] with correct data', () {
      final res = CourseModel.fromMap(tMap);
      expect(res, equals(tCourseModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with proper data', () {
      final result = tCourseModel.toMap()
        ..remove('createdAt')
        ..remove('updatedAt');

      final map = DataMap.from(tMap)
        ..remove('createdAt')
        ..remove('updatedAt');
      expect(result, equals(map));
    });
  });

  group('copyWith', () {
    test('should return a [CourseModel] with a new data', () {
      final res = tCourseModel.copyWith(title: 'newtitle');

      expect(res.title, 'newtitle');
    });
  });
}

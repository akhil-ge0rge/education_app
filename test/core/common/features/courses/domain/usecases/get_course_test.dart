import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/repo/course_repo.dart';
import 'package:education_app/core/common/features/courses/domain/usecases/get_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_course_repo.dart';

void main() {
  late CourseRepo repo;
  late GetCourse usecase;

  setUp(() {
    repo = MockCourseRepo();
    usecase = GetCourse(repo);
  });

  test(
    'should get course from repo',
    () async {
      when(() => repo.getCourse()).thenAnswer((_) async => const Right([]));

      final result = await usecase();

      expect(result, const Right<dynamic, List<Course>>([]));

      verify(() => repo.getCourse()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}

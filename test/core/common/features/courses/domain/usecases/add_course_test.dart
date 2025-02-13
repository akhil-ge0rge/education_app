import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/repo/course_repo.dart';
import 'package:education_app/core/common/features/courses/domain/usecases/add_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_course_repo.dart';

void main() {
  late AddCourse usecase;
  late CourseRepo repo;
  final tCourse = Course.empty();
  setUp(() {
    repo = MockCourseRepo();
    usecase = AddCourse(repo);
    registerFallbackValue(tCourse);
  });

  test(
    'should call [CourseRepo.addCourse]',
    () async {
      when(() => repo.addCourse(any()))
          .thenAnswer((invocation) async => const Right(null));

      await usecase.call(tCourse);

      verify(
        () => repo.addCourse(tCourse),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}

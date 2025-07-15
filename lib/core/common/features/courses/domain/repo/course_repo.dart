import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/utils/typedef.dart';

abstract class CourseRepo {
  const CourseRepo();
  ResultFuture<List<Course>> getCourse();

  ResultFuture<void> addCourse(Course course);
}

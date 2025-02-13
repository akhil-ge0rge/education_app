import 'package:education_app/core/common/features/courses/data/model/course_model.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';

abstract class CourseRemoteDatasources {
  Future<List<CourseModel>> getCourse();
  Future<void> addCourse(Course course);
}

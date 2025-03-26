import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/repo/course_repo.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';

class AddCourse extends UseCaseWithParams<void, Course> {
  AddCourse(this._courseRepo);
  final CourseRepo _courseRepo;
  @override
  ResultFuture<void> call(Course params) async => _courseRepo.addCourse(params);
}

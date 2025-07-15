import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/repo/course_repo.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedef.dart';

class GetCourse extends UseCaseWithOutParams<List<Course>> {
  GetCourse(this._courseRepo);
  final CourseRepo _courseRepo;
  @override
  ResultFuture<List<Course>> call() async => _courseRepo.getCourse();
}

import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/courses/data/datasources/course_remote_datasources.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/common/features/courses/domain/repo/course_repo.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedef.dart';

class CourseRepoImpl implements CourseRepo {
  const CourseRepoImpl(this._courseRemoteDataSource);
  final CourseRemoteDatasources _courseRemoteDataSource;
  @override
  ResultFuture<void> addCourse(Course course) async {
    try {
      await _courseRemoteDataSource.addCourse(course);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Course>> getCourse() async {
    try {
      final res = await _courseRemoteDataSource.getCourse();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}

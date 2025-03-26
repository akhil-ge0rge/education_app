import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/courses/data/datasources/course_remote_datasources.dart';
import 'package:education_app/core/common/features/courses/data/model/course_model.dart';
import 'package:education_app/core/common/features/courses/data/repo/course_repo_impl.dart';
import 'package:education_app/core/common/features/courses/domain/entities/course.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDatasources {}

void main() {
  late CourseRemoteDatasources remoteDataSrc;
  late CourseRepoImpl repoImpl;

  final tCourse = CourseModel.empty();

  setUp(() {
    remoteDataSrc = MockCourseRemoteDataSource();
    repoImpl = CourseRepoImpl(remoteDataSrc);
    registerFallbackValue(tCourse);
  });
  const tException = ServerException(
    message: 'Something went wrong',
    statusCode: '500',
  );

  group('addCourse', () {
    test(
      'should complete sucessfully when call to remote source is sucessful',
      () async {
        when(() => remoteDataSrc.addCourse(any()))
            .thenAnswer((_) async => Future.value());

        final value = await repoImpl.addCourse(tCourse);
        expect(value, const Right<dynamic, void>(null));
        verify(() => remoteDataSrc.addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerException] when call to remote sources is '
      'unsucesfull',
      () async {
        when(() => remoteDataSrc.addCourse(any())).thenThrow(tException);
        final result = await repoImpl.addCourse(tCourse);
        expect(
          result,
          Left<Failure, void>(ServerFailure.fromException(tException)),
        );
        verify(() => remoteDataSrc.addCourse(tCourse)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group(
    'getCourse',
    () {
      test(
        'should return [List<Course>] when call to remote source is sucessfull',
        () async {
          when(() => remoteDataSrc.getCourse())
              .thenAnswer((_) async => [tCourse]);
          final res = await repoImpl.getCourse();

          expect(res, isA<Right<dynamic, List<Course>>>());

          verify(() => remoteDataSrc.getCourse()).called(1);
          verifyNoMoreInteractions(remoteDataSrc);
        },
      );

      test(
        'should return [ServerException] when call to remote sources is '
        'unsucesfull',
        () async {
          when(
            () => remoteDataSrc.getCourse(),
          ).thenThrow(tException);
          final res = await repoImpl.getCourse();
          expect(
            res,
            Left<Failure, dynamic>(ServerFailure.fromException(tException)),
          );
          verify(() => remoteDataSrc.getCourse()).called(1);
          verifyNoMoreInteractions(remoteDataSrc);
        },
      );
    },
  );
}

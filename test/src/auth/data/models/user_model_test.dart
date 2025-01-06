import 'dart:convert';

import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();

  test(
    'should be a subsclass of [LocalUser] entity',
    () => expect(tLocalUserModel, isA<LocalUser>()),
  );
  final tMap = jsonDecode(fixture('user.json')) as DataMap;
  group('fromMap', () {
    test(
      'should return a valid [LocalUserModel] from the map',
      () {
        final result = LocalUserModel.fromMap(tMap);

        expect(result, tLocalUserModel);
      },
    );

    test(
      'should return an [Error] if map is invalid',
      () {
        final map = DataMap.from(tMap)..remove('uid');
        const call = LocalUserModel.fromMap;
        expect(() => call(map), throwsA(isA<Error>()));
      },
    );
  });

  group(
    'toMap',
    () {
      test(
        'should return a valid [DataMap] from the model',
        () {
          final result = tLocalUserModel.toMap();

          expect(result, equals(tMap));
        },
      );
    },
  );

  group(
    'copyWith',
    () {
      test(
        'should return a valid [LocalUserModel] with updated values',
        () {
          final result = tLocalUserModel.copyWith(uid: '2222');

          expect(result.uid, '2222');
        },
      );
    },
  );
}

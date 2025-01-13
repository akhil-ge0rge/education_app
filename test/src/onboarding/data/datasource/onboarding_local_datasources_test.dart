import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/src/onboarding/data/datasources/onboarding_local_datasources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnboardingLocalDatasources localDataSrc;

  setUp(
    () {
      prefs = MockSharedPreferences();
      localDataSrc = OnboardingLocalDatasourcesImpl(prefs);
    },
  );

  group(
    'cacheFirstTimer',
    () {
      test(
        'should call [SharedPrefernces] to cache the data',
        () async {
          when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);
          await localDataSrc.cacheFirstTimer();
          verify(() => prefs.setBool(kFirstTimerKey, false));
          verifyNoMoreInteractions(prefs);
        },
      );
      test(
        'should throw a [CacheException] when '
        'there is an error in caching data',
        () async {
          when(() => prefs.setBool(any(), any()))
              .thenThrow((_) async => Exception());
          final methodCall = localDataSrc.cacheFirstTimer;
          expect(methodCall, throwsA(isA<CacheException>()));
          verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
          verifyNoMoreInteractions(prefs);
        },
      );
    },
  );

  group(
    'checkUserIsFirstUser',
    () {
      test(
        'should call [SharedPreferences] to check the user is first timer and '
        'return the right response from storage when data exist',
        () async {
          when(() => prefs.getBool(any())).thenReturn(false);
          final result = await localDataSrc.checkIfUserIsFirstTimer();

          expect(result, false);
          verify(
            () => prefs.getBool(kFirstTimerKey),
          );
          verifyNoMoreInteractions(prefs);
        },
      );
      test(
        'should return true if no data in storage',
        () async {
          when(() => prefs.getBool(any())).thenReturn(null);
          final result = await localDataSrc.checkIfUserIsFirstTimer();

          expect(result, true);
          verify(() => prefs.getBool(kFirstTimerKey));
          verifyNoMoreInteractions(prefs);
        },
      );
      test(
        'should throw a [CacheException] when there is a error '
        'retreving the data',
        () async {
          when(() => prefs.getBool(any())).thenThrow(Exception());
          final call = localDataSrc.checkIfUserIsFirstTimer;
          expect(call, throwsA(isA<CacheException>()));
          verify(() => prefs.getBool(kFirstTimerKey)).called(1);
        },
      );
    },
  );
}

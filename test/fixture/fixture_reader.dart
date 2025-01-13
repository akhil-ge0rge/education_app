import 'dart:io';

String fixture(String fileName) {
  return File('test/fixture/$fileName').readAsStringSync();
}

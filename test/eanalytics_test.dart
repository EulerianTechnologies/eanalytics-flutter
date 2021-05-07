import 'package:eanalytics/src/models/EAProperty.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eanalytics/src/eulerian.dart';

void main() {
  test('Eulerian class should always return singleton instance', () {
    expect(Eulerian(), Eulerian());
  });

  test('Calling track before init should throw', () {
    expect(() => Eulerian.track([EAProperty(path: '/test')]), throwsAssertionError);
  });
}

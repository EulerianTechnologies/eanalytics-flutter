import 'package:flutter_test/flutter_test.dart';
import 'package:eanalytics/eanalytics.dart';

void main() {
  test('Eulerian class should always return singleton instance', () {
    expect(Eulerian(), Eulerian());
  });

  test('Calling track before init should throw', () {
    expect(() => Eulerian.track(), throwsAssertionError);
  });
}

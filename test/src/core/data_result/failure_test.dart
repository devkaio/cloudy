import 'package:cloudy/src/core/data_result/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toString should return the overrided data', () {
    final failure = GeneralException('message');

    expect(failure.toString(), 'GeneralException: message');
  });
}

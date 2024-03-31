import 'package:cloudy/src/core/data_result/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DataResult.success should return success', () {
    final successResult = DataResult.success('Data from the datasource');

    expect(successResult.failure, isNull);
    expect(successResult.data, isNotNull);
    expect(successResult.data, isA<String>());
    expect(successResult.isSuccess, true);
    expect(successResult.isFailure, false);
  });

  test('DataResult.failure should return failure', () {
    final failedResult = DataResult.failure(GeneralException('Failed to get data from the datasource'));

    expect(failedResult.data, isNull);
    expect(failedResult.failure, isNotNull);
    expect(failedResult.failure, isA<GeneralException>());
    expect(failedResult.isSuccess, false);
    expect(failedResult.isFailure, true);
  });
}

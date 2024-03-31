import 'package:cloudy/src/core/dependencies/http/dio_service.dart';
import 'package:cloudy/src/core/dependencies/local_storage/shared_preferences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dio_service_test.mocks.dart';

@GenerateMocks([SharedPreferencesService, Dio])
void main() {
  late SharedPreferencesService sharedPreferencesService;
  late Dio dio;
  late DioService dioService;

  setUp(() {
    final fakeInterceptors = Interceptors();

    sharedPreferencesService = MockSharedPreferencesService();
    dio = MockDio();
    when(dio.interceptors).thenReturn(fakeInterceptors);

    dioService = DioService(
      sharedPreferencesService: sharedPreferencesService,
      dio: dio,
    );
  });

  group('DioService', () {
    test('get method should return success', () async {
      const url = 'https://api.openweathermap.org/data/2.5/weather?q=London';
      final headers = <String, String>{'Content-Type': 'application/json'};

      when(dio.get(url, options: anyNamed('options'))).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            statusMessage: 'OK',
            data: <String, dynamic>{},
          ));

      final response = await dioService.get(url, headers: headers);

      expect(response.statusCode, 200);
      expect(response.errorMessage, 'OK');
      expect(response.body, <String, dynamic>{});
    });

    test('get method should return error', () async {
      const url = 'https://api.openweathermap.org/data/2.5/weather?q=London';
      final headers = <String, String>{'Content-Type': 'application/json'};

      when(dio.get(url, options: anyNamed('options'))).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
          statusMessage: 'Not Found',
          data: <String, dynamic>{},
        ),
      ));

      await expectLater(dioService.get(url, headers: headers), completes);
    });
  });
}

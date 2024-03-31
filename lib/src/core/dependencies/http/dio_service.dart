import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../api/http_api.dart';
import '../../constants/app_constants.dart';
import '../local_storage/shared_preferences_service.dart';

class DioService implements HttpApi {
  factory DioService({required SharedPreferencesService sharedPreferencesService}) {
    _instance ??= DioService._internal(sharedPreferencesService: sharedPreferencesService);
    return _instance!;
  }

  DioService._internal({
    required SharedPreferencesService sharedPreferencesService,
  }) : _sharedPreferencesService = sharedPreferencesService {
    _dio.interceptors.addAll([
      LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        logPrint: (o) => log(
          o.toString(),
          name: 'DioService',
        ),
      ),
      CacheInterceptor(sharedPreferencesService: _sharedPreferencesService)
    ]);
  }

  static DioService? _instance;

  final SharedPreferencesService _sharedPreferencesService;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      queryParameters: {
        'appid': AppConstants.apiKey,
        'units': 'metric',
      },
    ),
  );

  @override
  Future<HttpResponse> get(String url, {Map<String, String>? headers}) async {
    final response = await _dio.get(url, options: Options(headers: headers));

    return DioReponse(
      statusCode: response.statusCode,
      errorMessage: response.statusMessage,
      body: response.data,
    );
  }
}

class DioReponse extends HttpResponse {
  DioReponse({
    super.statusCode,
    super.errorMessage,
    required super.body,
  });
}

class CacheInterceptor extends Interceptor {
  CacheInterceptor({
    required SharedPreferencesService sharedPreferencesService,
  }) : _sharedPreferencesService = sharedPreferencesService;

  final SharedPreferencesService _sharedPreferencesService;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    await _sharedPreferencesService.save(response.requestOptions.path, jsonEncode(response.data));

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.connectionError) {
      final cachedResponse = await _sharedPreferencesService.read(err.requestOptions.path);

      if (cachedResponse != null) {
        handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            data: jsonDecode(cachedResponse),
          ),
        );
        return;
      }
    }
    super.onError(err, handler);
  }
}

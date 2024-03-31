abstract class HttpApi {
  Future<HttpResponse> get(String url, {Map<String, String>? headers});
}

abstract class HttpResponse {
  HttpResponse({
    this.statusCode,
    this.errorMessage,
    required this.body,
  });

  final int? statusCode;
  final String? errorMessage;
  final dynamic body;
}

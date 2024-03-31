abstract class Failure implements Exception {
  Failure([this.message]);

  final String? message;

  @override
  String toString() => '$runtimeType: $message';
}

class GeneralException extends Failure {
  GeneralException([super.message]);
}

class WeatherRepositoryException extends Failure {
  WeatherRepositoryException([super.message]);
}

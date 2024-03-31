import 'dart:async';

abstract class LocalStorageApi {
  FutureOr<String?> read(String key);
  Future<void> save(String key, String value);
  Future<void> delete(String key);
  Future<void> init([dynamic plugin]);
}

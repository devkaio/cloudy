import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../../api/local_storage_api.dart';

class SharedPreferencesService implements LocalStorageApi {
  factory SharedPreferencesService() => _instance;

  SharedPreferencesService._internal();

  static final SharedPreferencesService _instance = SharedPreferencesService._internal();

  late final SharedPreferences _sharedPreferences;

  @override
  Future<void> delete(String key) async => await _sharedPreferences.remove(key);

  @override
  FutureOr<String?> read(String key) => _sharedPreferences.getString(key);

  @override
  Future<void> save(String key, String value) async => await _sharedPreferences.setString(key, value);

  @override
  Future<void> init([sharedPreferences]) async {
    _sharedPreferences = sharedPreferences;
  }
}

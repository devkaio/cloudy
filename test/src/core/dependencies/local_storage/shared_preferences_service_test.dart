import 'package:cloudy/src/core/dependencies/local_storage/shared_preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferencesService service;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();

    service = SharedPreferencesService();
    await service.init(sharedPreferences);
  });

  group('SharedPreferencesService tests', () {
    test('Tests save method', () async {
      const key = 'save_key';
      const value = 'content_to_save';
      await service.save(key, value);

      final result = sharedPreferences.getString(key);
      expect(result, isNotNull);
      expect(result, 'content_to_save');
    });

    test('Tests read method', () async {
      const key = 'read_key';
      const value = 'content_to_read';
      await sharedPreferences.setString(key, value);

      final result = await service.read(key);

      expect(result, isNotNull);
      expect(result, 'content_to_read');
    });

    test('Tests delete method', () async {
      const key = 'delete_key';
      const value = 'content_to_delete';
      await sharedPreferences.setString(key, value);

      await service.delete(key);

      final result = sharedPreferences.getString(key);
      expect(result, isNull);
    });
  });
}

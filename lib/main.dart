import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app_widget.dart';
import 'src/core/dependencies/local_storage/shared_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sp = await SharedPreferences.getInstance();

  await SharedPreferencesService().init(sp);

  runApp(const AppWidget());
}

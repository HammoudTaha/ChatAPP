import 'package:chatapp/core/utils/di.dart';
import 'package:flutter/material.dart';
import 'core/config/config_loading.dart';
import 'features/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  await getIt.allReady();
  runApp(const App());
  configLoading();
}

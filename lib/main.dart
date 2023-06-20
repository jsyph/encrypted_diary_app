import 'package:flutter/material.dart';

import 'services/services.dart';
import 'widgets/app_lock.dart' show AppLock;
import 'widgets/home.dart';
import 'widgets/lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DiaryAppServices.initialize();
  runApp(
    AppLock(
      builder: (arg) => const HomeWidget(),
      lockScreen: LockScreen(),
      theme: lightTheme,
      darkTheme: darkTheme,
    ),
  );
}

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);
final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);

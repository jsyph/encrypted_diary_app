import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class AppSecurity {
  static Future<void> addSecureFlag() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}

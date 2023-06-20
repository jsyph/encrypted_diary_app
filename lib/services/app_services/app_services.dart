import 'package:hive_flutter/hive_flutter.dart';

import '../security/security.dart';
import '../storage/storage.dart';
import 'record_storage_services.dart';
import 'security_services.dart';

abstract final class DiaryAppServices {
  const DiaryAppServices();

  static const records = RecordStorageServices();
  static const security = SecurityServices();

  /// Function to be run before `runApp`
  static Future<void> initialize() async {
    await Hive.initFlutter();
    RecordStorage.registerAdapters();
    await AppSecurity.addSecureFlag();
  }
}

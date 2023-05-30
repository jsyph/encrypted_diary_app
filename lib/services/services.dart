import 'security/security.dart';
import 'storage/storage.dart';

final class DiaryAppServices {
  const DiaryAppServices();

  static const _storage = Storage();
  static final _biometricSecurity = BiometricSecurity();

  /// Function to be run before `runApp`
  static Future<void> initialize() async {
    Storage.registerAdapters();
    await AppSecurity.addSecureFlag();
  }

  /// Authenticates user biometrics
  Future<bool> authenticateBiometrics() async {
    return await _biometricSecurity.authenticateFingerprint();
  }

  /// Opens the Database for usage
  Future<bool> openDatabase(String userPassword) async {
    final accessResult = await _storage.open(userPassword);

    return accessResult;
  }

  /// Gets all records
  Future<List<DiaryRecord>> allRecords(String userPassword) async {
    return _storage.all();
  }

  /// Adds a new diary record
  Future<void> addRecord(String title, String content) async {
    await _storage.add(title, content);
  }

  /// Modifies an existing diary record
  Future<void> modifyRecord(String id, String? title, String? content) async {
    await _storage.modify(id, title, content);
  }

  /// Removes a diary record
  Future<void> removeRecord(String id) async {
    await _storage.remove(id);
  }

  /// Deletes all records
  Future<void> deleteAllRecords() async {
    await _storage.clear();
  }
}

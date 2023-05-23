// import '../logging.dart';
import '../security/security.dart';
import '../storage/storage.dart';
import '../storage/storage_access.dart';
import 'result.dart';

final class Repository {
  const Repository._();
  static Storage? _storage;
  static final _security = Security();
  // static final _logger = Logging().logger;

  static Future<Repository> init() async {
    _storage = await Storage.init();
    return const Repository._();
  }

  /// Authenticates user biometrics
  Future<bool> authenticateBiometrics() async {
    return await _security.authenticateBiometrics();
  }

  /// Gets all records
  Future<AccessResult> allRecords(String userPassword) async {
    final accessResult = await _storage!.open(userPassword);
    if (accessResult == StorageAccessStatus.wrongPassword) {
      return AccessResultFailure();
    }

    return AccessResultSuccess(_storage!.all());
  }

  /// Adds a new diary record
  Future<void> addRecord(String title, String content) async {
    await _storage!.add(title, content);
  }

  /// Modifies an existing diary record
  Future<void> modifyRecord(String id, {String? title, String? content}) async {
    await _storage!.modify(id, title: title, content: content);
  }

  /// Removes a diary record
  Future<void> removeRecord(String id) async {
    await _storage!.remove(id);
  }

  /// Deletes all records
  Future<void> deleteAllRecords() async {
    await _storage!.delete();
  }
}

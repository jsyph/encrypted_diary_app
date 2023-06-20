import '../storage/storage.dart';

final class RecordStorageServices {
  const RecordStorageServices();

  static const _storage = RecordStorage();

  /// Opens the Database for usage
  Future<bool> openDatabase(String userPassword) async {
    final accessResult = await _storage.open(userPassword);

    return accessResult;
  }

  Future<bool> databaseExists() async {
    return _storage.dbExists();
  }

  /// Gets all records
  Future<List<DiaryRecord>> allRecords() async {
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

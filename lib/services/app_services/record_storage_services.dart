import '../storage/storage.dart';

final class RecordStorageServices {
  const RecordStorageServices();

  static const _storage = RecordStorage();

  /// Opens the Database for usage
  Future<bool> open(String userPassword) async {
    return await _storage.open(userPassword);
  }

  Future<bool> dbExists() async {
    return await _storage.dbExists();
  }

  /// Gets all records
  List<DiaryRecord> all() {
    return _storage.all();
  }

  /// Adds a new diary record
  Future<String> add({
    required String title,
    required String content,
  }) async {
    return await _storage.add(title, content);
  }

  /// Modifies an existing diary record
  Future<void> modify({
    required String id,
    String? title,
    String? content,
  }) async {
    await _storage.modify(id, title, content);
  }

  /// Removes a diary record
  Future<void> delete(String id) async {
    await _storage.delete(id);
  }

  /// Deletes all records
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  DiaryRecord? get(String id) {
    return _storage.get(id);
  }
}

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../security/security.dart';
import 'exceptions.dart';
import 'models/models.dart';

export 'models/models.dart' show DiaryRecord;

const _defaultRecordsBoxName = 'records';

/// Responsible for managing the encrypted storage
final class RecordStorage {
  const RecordStorage();

  static void registerAdapters() {
    Hive.registerAdapter(DiaryRecordAdapter());
  }

  static Box<DiaryRecord>? _box;
  static const _security = StorageSecurity();

  Future<bool> dbExists() async {
    return await _security.hiveKeyExists() &&
        await Hive.boxExists(_defaultRecordsBoxName);
  }

  /// Creates a new encrypted box if non exist
  /// or Retrieves a previously opened encrypted box
  /// Returns true if successful
  Future<bool> open(String userPassword) async {
    if (_box == null) {
      if (!(await dbExists())) {
        _box = await Hive.openBox(
          _defaultRecordsBoxName,
          encryptionCipher: HiveAesCipher(
            await _security.newHiveKey(userPassword),
          ),
        );
        return true;
      }
    }

    final result = await _security.getHiveKey(userPassword);
    // if the password was wrong, then return wrong password
    if (result is DecryptionSuccess) {
      _box = await Hive.openBox(
        _defaultRecordsBoxName,
        encryptionCipher: HiveAesCipher(result.result!),
      );
      return true;
    } else {
      // password is wrong
      return false;
    }
  }

  /// Adds new record to storage
  Future<String> add(String title, String content) async {
    final uniqueId = const Uuid().v4();
    await _box!.put(
      uniqueId,
      DiaryRecord(
        uniqueId,
        title,
        content,
        DateTime.now(),
        DateTime.now(),
      ),
    );
    return uniqueId;
  }

  /// Modifies an existing record by its id
  Future<void> modify(String id, String? title, String? content) async {
    final record = _box!.get(id);

    if (record == null) {
      throw RecordDoesNotExist();
    }

    record.lastModified = DateTime.now();

    if (title != null) {
      record.title = title;
    }

    if (content != null) {
      record.content = content;
    }

    await _box!.put(id, record);
  }

  /// Removes a record by its id
  Future<void> delete(String id) async {
    await _box!.delete(id);
  }

  List<DiaryRecord> all() {
    return _box!.toMap().values.toList();
  }

  /// Get record by id
  DiaryRecord? get(String id) {
    return _box!.get(id);
  }

  /// Clears all values from storage, without deleting the box
  Future<void> deleteAll() async {
    // delete all values from box, without closing the box
    await _box!.deleteAll(
      _box!.values.map((e) => e.id),
    );
  }
}

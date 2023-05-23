import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../security/security.dart';
import 'exceptions.dart';
import 'storage_access.dart';

const _defaultRecordsBoxName = 'records';

/// Responsible for managing the encrypted storage
final class Storage {
  const Storage._();

  static Box<DiaryRecord>? _box;
  static final _security = Security();

  static Future<Storage> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecordAdapter());

    return const Storage._();
  }

  /// Creates a new encrypted box if non exist
  /// or Retrieves a previously opened encrypted box
  Future<StorageAccessStatus> open(String userPassword) async {
    // if _box is not null then return StorageAccessStatus.granted
    if (_box != null) {
      return StorageAccessStatus.granted;
    }
    // If there is no key stored and no box exists then create new key and box
    if (!(await _security.hiveKeyExists()) &&
        !(await Hive.boxExists(_defaultRecordsBoxName))) {
      _box = await Hive.openBox(
        _defaultRecordsBoxName,
        encryptionCipher: HiveAesCipher(
          await _security.newHiveKey(userPassword),
        ),
      );
      return StorageAccessStatus.granted;
    }

    final decryptionResult = await _security.getHiveKey(userPassword);
    // if the password was wrong, then return wrong password
    if (decryptionResult is DecryptionSuccess) {
      _box = await Hive.openBox(
        _defaultRecordsBoxName,
        encryptionCipher: HiveAesCipher(decryptionResult.result!),
      );
      return StorageAccessStatus.granted;
    } else {
      // password is wrong
      return StorageAccessStatus.wrongPassword;
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
  Future<void> modify(String id, {String? title, String? content}) async {
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
  Future<void> remove(String id) async {
    await _box!.delete(id);
  }

  List<DiaryRecord> all() {
    return _box!.toMap().values.toList();
  }

  Future<void> delete() async {
    await _box!.deleteFromDisk();
  }
}

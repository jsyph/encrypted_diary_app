import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../logging.dart';
import 'decryption_result.dart';
import 'exceptions.dart';

export 'decryption_result.dart';

const _defaultIVLength = 8;
const _defaultSecureStorageKeyName = 'key';
const _defaultSecureStorageKeyHashName = 'key_hash';
const _defaultHiveSecureKeyLength = 32;

/// Contains all the methods necessary to securely hash, encrypt, and decrypt data
/// Things that are stored on the phone:
/// - hashed unencrypted password
/// - encrypted hive key
final class StorageSecurity {
  static final _logger = Logging().logger;
  static const _secureKeyStorage = FlutterSecureStorage();

  const StorageSecurity();

  /// Checks if a hive key is found
  Future<bool> hiveKeyExists() async {
    final hiveKey =
        await _secureKeyStorage.read(key: _defaultSecureStorageKeyName);
    if (hiveKey == null) {
      return false;
    }
    return true;
  }

  /// Creates a new hive key, and securely stores it
  Future<List<int>> newHiveKey(String userPassword) async {
    final secureRandom = SecureRandom(_defaultHiveSecureKeyLength);
    await storeHiveKey(userPassword, secureRandom.base64);

    return secureRandom.bytes;
  }

  /// Retrieves and decrypts the Hive encryption key using a password String
  Future<DecryptionResult> getHiveKey(String userPassword) async {
    // create password hash
    final hashedPassword = _hashStringSHA256(userPassword);
    _logger.v('Hashed Password Length = ${hashedPassword.length}');

    final decryptionKey = Key.fromUtf8(hashedPassword);
    _logger.v('Decryption Key Length = ${decryptionKey.length}');

    // get base64 encrypted key
    final hiveEncryptedKey =
        await _secureKeyStorage.read(key: _defaultSecureStorageKeyName);

    if (hiveEncryptedKey == null) {
      _logger.e('Key Not Found');
      throw KeyNotFoundError();
    }

    final encrypter = Encrypter(Salsa20(decryptionKey));

    final hiveDecryptedKey = encrypter.decrypt(
      Encrypted.fromBase64(hiveEncryptedKey),
      iv: IV.fromLength(_defaultIVLength),
    );

    // compare the current key hash with the stored key hatch
    final hiveDecryptedKeyHash = _hashStringSHA256(hiveDecryptedKey);

    final storedKeyHash =
        await _secureKeyStorage.read(key: _defaultSecureStorageKeyHashName);

    if (hiveDecryptedKeyHash == storedKeyHash) {
      _logger.i('Decryption Success');
      return DecryptionSuccess(
        utf8.encode(hiveDecryptedKey),
      );
    }

    return DecryptionFailure();
  }

  Future<void> storeHiveKey(String userPassword, String hiveKey) async {
    // generate password hash
    final hashedUserPassword = _hashStringSHA256(userPassword);
    _logger.v('Hashed User Password Length = ${hashedUserPassword.length}');

    final encryptionKey = Key.fromUtf8(hashedUserPassword);
    _logger.v('Encryption Key Length = ${encryptionKey.length}');

    final encrypter = Encrypter(Salsa20(encryptionKey));

    final encryptedHiveKey = encrypter.encrypt(
      hiveKey,
      iv: IV.fromLength(_defaultIVLength),
    );

    final base64EncryptedKey = encryptedHiveKey.base64;
    await _secureKeyStorage.write(
      key: _defaultSecureStorageKeyName,
      value: base64EncryptedKey,
    );

    _logger.i('Encryption Successful');

    // stores hash of unencrypted key for validation during decryption
    await _secureKeyStorage.write(
      key: _defaultSecureStorageKeyHashName,
      value: _hashStringSHA256(hiveKey),
    );
  }

  /// Hashes a string using sha256
  String _hashStringSHA256(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }
}

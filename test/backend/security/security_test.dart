import 'package:encrypted_diary_app/backend/security/security.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FlutterSecureStorage.setMockInitialValues({});
  const security = Security();
  test(
    'Test setHiveKey',
    () async {},
  );
}

import '../security/security.dart';

class SecurityServices {
  const SecurityServices();

  static final _biometricSecurity = BiometricSecurity();

  /// Authenticates fingerprint
  Future<bool> authenticateFingerPrint() async {
    return await _biometricSecurity.authenticateFingerprint();
  }
}

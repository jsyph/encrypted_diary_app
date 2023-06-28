import '../security/security.dart';

class SecurityServices {
  const SecurityServices();

  static final _biometricSecurity = BiometricSecurity();

  /// Authenticates fingerprint
  Future<bool> authenticateBiometrics(
      {required void Function() onPlatformException}) async {
    return await _biometricSecurity
        .authenticateFingerprint(onPlatformException);
  }
}

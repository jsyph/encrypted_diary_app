import 'package:local_auth/local_auth.dart';

// TODO: CRATE BIOMETRIC AUTHENTICATION
class BiometricSecurity {
  final _localAuthentication = LocalAuthentication();

  Future<bool> authenticateFingerprint() async {
    final isAuthenticated = await _localAuthentication.authenticate(
      localizedReason: 'Authenticate Fingerprint to Enter',
      options: const AuthenticationOptions(
        stickyAuth: true,
        sensitiveTransaction: true,
        biometricOnly: true,
      ),
    );
    return isAuthenticated;
  }
}

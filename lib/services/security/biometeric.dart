import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricSecurity {
  final _localAuthentication = LocalAuthentication();

  Future<bool> authenticateFingerprint(
    void Function() onPlatformException,
  ) async {
    Future<bool> doAuth() async {
      try {
        return await _localAuthentication.authenticate(
          options: const AuthenticationOptions(
            sensitiveTransaction: true,
            useErrorDialogs: true,
            biometricOnly: true,
            stickyAuth: true,
          ),
          localizedReason: 'Authenticate to continue.',
        );
      } on PlatformException catch (_) {
        onPlatformException();
        
        await Future.delayed(const Duration(seconds: 30));

        return false;
      }
    }

    bool didAuthenticate = false;
    while (!didAuthenticate) {
      if (await doAuth()) {
        didAuthenticate = true;
        return true;
      }
    }

    return false;
  }
}

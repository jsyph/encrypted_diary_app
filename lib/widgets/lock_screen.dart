import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:local_auth/local_auth.dart';

import '../services/services.dart';
import 'app_lock.dart';

class LockScreen extends StatelessWidget {
  LockScreen({super.key});

  final scaffoldState = GlobalKey<ScaffoldState>();

  Future<bool> _localAuth(
      {required Future<void> Function() onException}) async {
    final localAuth = LocalAuthentication();
    try {
      final didAuthenticate = await localAuth.authenticate(
        options: const AuthenticationOptions(
          sensitiveTransaction: true,
          useErrorDialogs: true,
          biometricOnly: true,
          stickyAuth: true,
        ),
        localizedReason: 'Authenticate to continue.',
      );
      return didAuthenticate;
    } on PlatformException catch (_) {
      await onException();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: FutureBuilder(
        future: DiaryAppServices.records.databaseExists(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.data!) {
            return ScreenLock.create(
              onConfirmed: (value) async {
                AppLock.of(context)!.didUnlock();
                await DiaryAppServices.records.openDatabase(value);
              },
              digits: 6,
              title: const Column(
                children: [
                  Text("You don't have a password"),
                  Text('Create a new one.'),
                  Text(
                    'This can only be done once.',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
              confirmTitle: const Column(
                children: [
                  Text("You're nearly there."),
                  Text('Confirm your new password.'),
                ],
              ),
              config: _screenLockConfig(context),
            );
          }

          bool isBiometricAuthenticated = false;

          return ScreenLock(
            useBlur: false,
            correctString: '||||||',
            customizedButtonChild: const Icon(Icons.fingerprint),
            customizedButtonTap: () async =>
                isBiometricAuthenticated = await _localAuth(
              onException: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    showCloseIcon: true,
                    duration: Duration(seconds: 30),
                    content: Column(
                      children: [
                        Text('Biometrics are disabled for 30 seconds'),
                        Text('All attempts will be ignored.')
                      ],
                    ),
                  ),
                );
              },
            ),
            onOpened: () async => isBiometricAuthenticated = await _localAuth(
              onException: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    showCloseIcon: true,
                    duration: Duration(seconds: 30),
                    content: Column(
                      children: [
                        Text('Biometrics are disabled for 30 seconds'),
                        Text('All attempts will be ignored.')
                      ],
                    ),
                  ),
                );
              },
            ),
            title: const Text('Enter Password to Continue'),
            config: _screenLockConfig(context),
            onUnlocked: () {
              AppLock.of(context)!.didUnlock();
            },
            onValidate: (input) async {
              if (isBiometricAuthenticated &&
                  await DiaryAppServices.records.openDatabase(input)) {
                isBiometricAuthenticated = false;
                return true;
              }
              return false;
            },
          );
        },
      ),
    );
  }
}

ScreenLockConfig _screenLockConfig(BuildContext context) {
  return ScreenLockConfig(
    themeData: Theme.of(context),
    buttonStyle: ElevatedButton.styleFrom(
      side: const BorderSide(width: 0, color: Colors.transparent),
    ),
  );
}

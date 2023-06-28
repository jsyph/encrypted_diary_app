import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '../services/services.dart';
import 'app_lock.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool _blockInput = false;

  ScreenLockConfig _screenLockConfig(BuildContext context) {
    return ScreenLockConfig(
      titleTextStyle: _getTitleTextStyle(context),
      backgroundColor: Theme.of(context).primaryColor,
      buttonStyle: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColorLight,
        side: const BorderSide(width: 0, color: Colors.transparent),
      ),
    );
  }

  TextStyle _getTitleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).primaryColorLight,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IgnorePointer(
          ignoring: _blockInput,
          child: Scaffold(
            body: FutureBuilder(
              future: DiaryAppServices.records.dbExists(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!(snapshot.data!)) {
                  return ScreenLock.create(
                    onConfirmed: (value) async {
                      await DiaryAppServices.records.open(value);

                      if (mounted) {
                        AppLock.of(context)!.onUnlock();
                      }
                    },
                    digits: 6,
                    title: Column(
                      children: [
                        Text(
                          "You don't have a password",
                          style: _getTitleTextStyle(context),
                        ),
                        Text(
                          'Create a new one.',
                          style: _getTitleTextStyle(context),
                        ),
                        const Text(
                          'This can only be done once.',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    confirmTitle: Column(
                      children: [
                        Text(
                          "You're nearly there.",
                          style: _getTitleTextStyle(context),
                        ),
                        Text(
                          'Confirm your new password.',
                          style: _getTitleTextStyle(context),
                        ),
                        const Text(''),
                      ],
                    ),
                    config: _screenLockConfig(context),
                  );
                }

                bool isBiometricAuthenticated = false;

                return ScreenLock(
                  maxRetries: 3,
                  retryDelay: const Duration(seconds: 15),
                  useBlur: false,
                  correctString: '||||||',
                  onOpened: () async => isBiometricAuthenticated =
                      await DiaryAppServices.security.authenticateBiometrics(
                    onPlatformException: () {
                      if (context.mounted) {
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

                        setState(() {
                          _blockInput = true;
                        });

                        Timer(
                          const Duration(seconds: 30),
                          () => setState(() {
                            _blockInput = false;
                          }),
                        );
                      }
                    },
                  ),
                  title: const Text('Enter Password to Continue'),
                  config: _screenLockConfig(context),
                  onUnlocked: () {
                    AppLock.of(context)!.onUnlock();
                  },
                  onValidate: (input) async {
                    if (isBiometricAuthenticated &&
                        await DiaryAppServices.records.open(input)) {
                      isBiometricAuthenticated = false;
                      return true;
                    }
                    return false;
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

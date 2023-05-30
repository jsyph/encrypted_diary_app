import 'package:flutter/material.dart';

import '../services/logging.dart';
import 'password_entry.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with WidgetsBindingObserver {
  static const bool _isAuthenticated = false;
  static bool _wasBackgroundOrInActive = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logging().logger.d(state);
    setState(() {
      _wasBackgroundOrInActive = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_wasBackgroundOrInActive || !_isAuthenticated) {
          _wasBackgroundOrInActive = false;
          return AuthenticationPageWidget();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Encrypted Diary'),
          ),
          body: const Center(
            child: Text('Hello'),
          ),
        );
      },
    );
  }
}

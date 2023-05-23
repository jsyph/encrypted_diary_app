import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'backend/security/security.dart';

void main() async {
  runApp(const MyApp());
}

final LocalAuthentication auth = LocalAuthentication();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const unEncryptedHiveKey =
      r'123';

  static const userPassword = 'test123';

  final security = Security();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          const Text(unEncryptedHiveKey),
          MaterialButton(
            child: const Text('Encrypt password'),
            onPressed: () {
              security
                  .storeHiveKey(userPassword, unEncryptedHiveKey)
                  .then((value) => null);
            },
          ),
          MaterialButton(
            child: const Text('Decrypt password'),
            onPressed: () {
              security.getHiveKey(userPassword).then((value) => null);
            },
          ),
        ],
      )),
    );
  }
}

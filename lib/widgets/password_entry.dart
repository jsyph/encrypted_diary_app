import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import 'home.dart';

class AuthenticationPageWidget extends StatelessWidget {
  AuthenticationPageWidget({super.key});

  final _controller = TextEditingController();

  InputBorder _textFieldInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Authentication Required'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      decoration: InputDecoration(
                        constraints: const BoxConstraints.tightFor(width: 300),
                        border: InputBorder.none,
                        focusedBorder: _textFieldInputBorder(context),
                        enabledBorder: _textFieldInputBorder(context),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        counter: null,
                        counterText: '',
                        labelText: 'Enter Your Password',
                        hintStyle: const TextStyle(
                          letterSpacing: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                      controller: _controller,
                      readOnly: false,
                      autofocus: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: GET PASSWORD FROM CONTROLLER AND OPEND DATABASE USING IT AND VALIDATE IT

                        //!! TEMPORARY
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 500),
                            child: const HomeWidget(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.lock_open),
                      label: const Text('UnLock'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 40),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

Color invert(Color color) {
  final r = 255 - color.red;
  final g = 255 - color.green;
  final b = 255 - color.blue;

  return Color.fromARGB((color.opacity * 255).round(), r, g, b);
}

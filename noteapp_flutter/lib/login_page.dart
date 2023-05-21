import 'package:flutter/material.dart';
import 'package:noteapp_flutter/serverpod_client.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';


/// TODO: Finish the docs
/// LoginPage to...
class LoginPage extends StatelessWidget {
  /// Static named route for page
  static const String route = 'Login';

  /// Static method to return the widget as a PageRoute
  static Route go() => MaterialPageRoute<void>(builder: (_) => LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Dialog(
          child: Container(
            width: 260,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.security,
                  size: 200,
                ),
                SignInWithEmailButton(
                  caller: client.modules.auth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

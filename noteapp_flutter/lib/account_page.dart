import 'package:flutter/material.dart';
import 'package:noteapp_flutter/serverpod_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';


/// TODO: Finish the docs
/// AccountPage to...
class AccountPage extends StatelessWidget {
  /// Static named route for page
  static const String route = 'Account';

  /// Static method to return the widget as a PageRoute
  static Route go() => MaterialPageRoute<void>(builder: (_) => AccountPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Account"),),
        body: ListView(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          leading: CircularUserImage(
            userInfo: sessionManager.signedInUser,
            size: 42,
          ),
          title: Text(sessionManager.signedInUser!.userName),
          subtitle: Text(sessionManager.signedInUser!.email ?? ''),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              sessionManager.signOut();
            },
            child: const Text('Sign out'),
          ),
        ),
      ],
    ));
  }
}

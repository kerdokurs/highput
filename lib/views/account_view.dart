import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: TextButton(
        onPressed: () async {
          await FirebaseMessaging.instance.deleteToken();
          // TODO: Remove the token from db
          await FirebaseAuth.instance.signOut();
        },
        child: Text('Sign out'),
      )),
    );
  }
}

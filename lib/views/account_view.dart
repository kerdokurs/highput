import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: TextButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        child: Text('Sign out'),
      )),
    );
  }
}

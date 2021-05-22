import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:highput/views/auth/sign_in_view.dart';
import 'package:highput/views/main_view.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _loggedIn = false;

  void updateLoggedIn(bool loggedIn) {
    if (!mounted) return;

    setState(() {
      _loggedIn = loggedIn;
    });
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      updateLoggedIn(user != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn) return SignInView();

    return MainView();
  }
}

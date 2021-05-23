import 'package:flutter/material.dart';
import 'package:highput/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(HighPutApp());
}

class HighPutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'WorkSans',
      ),
      debugShowCheckedModeBanner: false,
      home: AuthenticationWrapper(),
    );
  }
}

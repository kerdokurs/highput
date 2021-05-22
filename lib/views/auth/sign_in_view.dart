import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:highput/services/auth.dart';
import 'package:highput/views/auth/sign_up_view.dart';

class SignInView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.up,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpView(),
                          ),
                        );
                      },
                      child: Text('Sign up'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        primary: Colors.black87, // TODO: Specify
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpView(),
                          ),
                        );
                      },
                      child: Text('Forgot password?'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        primary: Colors.black87, // TODO: Specify
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 0,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // final auth = Provider.of<AuthService>(
                    //   context,
                    //   listen: false,
                    // );
                    // final resp = await auth.signInWithEmailAndPassword(
                    //   email: emailController.text.trim(),
                    //   password: passwordController.text.trim(),
                    // );
                    // print(resp);
                    // emailController.clear();
                    // passwordController.clear();
                  },
                  child: Text('Log in with Google'),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    minimumSize: Size(
                      double.infinity,
                      18.0,
                    ),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 4,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) return;

                    final status = await signInWithEmailAndPassword(
                        email: email, password: password);

                    print(status);

                    emailController.clear();
                    passwordController.clear();
                  },
                  child: Text('Log in'),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    minimumSize: Size(
                      double.infinity,
                      18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 0,
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 0,
                  ),
                ),
                Text(
                  'Login',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

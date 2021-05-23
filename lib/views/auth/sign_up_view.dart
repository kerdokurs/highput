import 'package:flutter/material.dart';
import 'package:highput/services/auth.dart';

class SignUpView extends StatelessWidget {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 20.0,
                      // FIXME: icon off-center (caused by padding)
                      icon: Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 0,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty)
                          return; // TODO: Add red border?

                        final status =
                            await signUpWithEmailAndPassword(email, password);

                        if (status.error) {
                          print(status.message);
                          // TODO: Display error
                          return;
                        }

                        Navigator.pop(context);
                      },
                      child: Text('Sign up'),
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:highput/services/auth.dart';

class ResetPasswordView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

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
                      icon: Icon(
                        Icons.arrow_back_ios,
                      ),
                    )
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 0,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = emailController.text.trim();

                        if (email.isEmpty) return; // TODO: Add red border?

                        final status = await resetPassword(email);
                        print(status.message);

                        // Navigator.pop(context);
                      },
                      child: Text('Reset password'),
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

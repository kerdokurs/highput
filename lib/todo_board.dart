import 'package:flutter/material.dart';

class TodoBoard extends StatelessWidget {
  const TodoBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 200,
      child: Card(
        color: Colors.redAccent,
        elevation: 6,
        shadowColor: Colors.blueGrey,
        child: Center(
          child: Text(
            'test',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

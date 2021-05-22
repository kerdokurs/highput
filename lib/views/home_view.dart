import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highput/todo_board.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 0,
          //     vertical: 200,
          //   ),
          // ),
          // Container(
          //   color: Colors.blue,
          //   child: Text(
          //     'Good morning, Kerdo!',
          //     style: Theme.of(context).textTheme.headline6,
          //     textAlign: TextAlign.left,
          //   ),
          // ),
          Center(
            child: Container(
              height: 200,
              alignment: Alignment.centerLeft,
              child: ListView.separated(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                itemBuilder: (context, i) {
                  return TodoBoard();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 10,
                  );
                },
                // scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

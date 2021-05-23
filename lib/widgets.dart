import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:highput/views/task_view.dart';

import 'models/todo.dart';
import 'models/todo_board.dart';

class TaskCard extends StatelessWidget {
  final TodoBoard board;
  final DocumentReference<TodoBoard> ref;

  TaskCard({required this.board, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskView(board, ref),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              board.title,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                board.description,
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskTodo extends StatelessWidget {
  final Todo todo;
  final DocumentReference<Todo> ref;

  TaskTodo({required this.todo, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: 12.0,
                  ),
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: todo.isDone ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: todo.isDone ? Colors.green : Colors.black,
                    ),
                  ),
                  child: SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        await ref.update({
                          'isDone': !todo.isDone,
                        });
                      },
                      icon: Icon(
                        Icons.done,
                        size: 16.0,
                        color: todo.isDone ? Colors.white : Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Text(
                  todo.content,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: todo.isDone ? Color(0xff211551) : Color(0xff98929d),
                    fontWeight: todo.isDone ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReminderCard extends StatelessWidget {
  final TextEditingController timeController = TextEditingController();

  final String title;
  final String time;
  final DocumentReference ref;

  ReminderCard(this.title, this.time, this.ref);

  @override
  Widget build(BuildContext context) {
    timeController.text = time;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: SizedBox(
                    width: 50,
                    child: TextField(
                      onEditingComplete: () async {
                        final time = timeController.text.trim();
                        final pieces = time.split(':');
                        final now = DateTime.now();

                        try {
                          int hour = int.tryParse(pieces[0]) ?? now.hour;
                          int minute = int.tryParse(pieces[1]) ?? now.minute;

                          if (hour < 0 ||
                              hour > 24 ||
                              minute < 0 ||
                              minute > 60) {
                            //TODO: Error
                            return;
                          }

                          await ref.update({
                            'time': hour.toString() + ':' + minute.toString(),
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      controller: timeController,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
                await ref.delete();
              },
              iconSize: 28.0,
              color: Colors.redAccent,
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

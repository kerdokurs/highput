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
                color: Color(0xff211551),
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
            margin: EdgeInsets.only(
              right: 12.0,
            ),
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                color: todo.isDone ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: todo.isDone ? Colors.green : Colors.black,
                )),
            child: Icon(
              Icons.done,
              size: 16.0,
              color: todo.isDone ? Colors.white : Colors.transparent,
            ),
          ),
          Text(
            todo.content,
            style: TextStyle(
              fontSize: 16.0,
              color: todo.isDone ? Color(0xff211551) : Color(0xff98929d),
              fontWeight: todo.isDone ? FontWeight.w600 : FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

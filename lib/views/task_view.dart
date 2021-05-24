import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:highput/models/todo.dart';
import 'package:highput/models/todo_board.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets.dart';

class TaskView extends StatefulWidget {
  TodoBoard? board;
  DocumentReference<TodoBoard>? ref;

  TaskView(TodoBoard? board, DocumentReference<TodoBoard>? ref) {
    this.board = board;
    this.ref = ref;
  }

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  StreamSubscription<QuerySnapshot<Todo>>? subscription;
  List<TaskTodo> _todos = List.empty();

  void setTodos(List<TaskTodo> todos) {
    if (!mounted) return;

    setState(() {
      _todos = todos;
    });
  }

  void setBoard(TodoBoard? board) {
    setState(() {
      widget.board = board;
      titleController.text = board!.title;
      descriptionController.text = board.description;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (subscription != null) subscription!.cancel();
  }

  @override
  void initState() {
    super.initState();

    if (widget.board == null) {
      widget.ref = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('boards')
          .withConverter(
            fromFirestore: (snapshot, _) =>
                TodoBoard.fromJson(snapshot.data()!),
            toFirestore: (TodoBoard model, _) => model.toJson(),
          )
          .doc();

      widget.ref!.set(TodoBoard('Untitled', '', DateTime.now()));
    }

    widget.ref!.get().then((value) {
      final board = value.data();
      setBoard(board);
    });

    subscription = widget.ref!
        .collection('todos')
        .orderBy('isDone')
        .orderBy('created_at', descending: true)
        .withConverter(
          fromFirestore: (snapshot, _) => Todo.fromJson(snapshot.data()!),
          toFirestore: (Todo model, _) => model.toJson(),
        )
        .snapshots()
        .listen(
      (event) {
        List<TaskTodo> todos = List.generate(
          event.docs.length,
          (i) => TaskTodo(
              todo: event.docs[i].data(), ref: event.docs[i].reference),
        );
        setTodos(todos);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 24.0,
            left: 24.0,
            right: 24.0,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 8.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await subscription!.cancel();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios),
                        ),
                        Expanded(
                          child: TextField(
                            controller: titleController,
                            onEditingComplete: () async {
                              if (widget.ref == null) {
                                initState();
                                return;
                              }

                              await widget.ref!.update({
                                'title': titleController.text.trim(),
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Task title',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      bottom: 12.0,
                    ),
                    child: TextField(
                      controller: descriptionController,
                      onEditingComplete: () async {
                        await widget.ref!.update({
                          'description': descriptionController.text.trim(),
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Task description',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: _todos,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.redAccent,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.delete_forever),
                    iconSize: 32.0,
                    onPressed: () async {
                      if (widget.ref != null) {
                        await widget.ref!.delete();
                      }
                      await subscription!.cancel();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 100.0,
                right: 0.0,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.add),
                    iconSize: 32.0,
                    onPressed: () async {
                      await newTask(context, widget.ref!);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> newTask(BuildContext context, DocumentReference<TodoBoard> ref) {
  String content = '';

  return showDialog(
    context: context,
    barrierDismissible: false,
    // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter new task'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Task content',
                  hintText: 'Finish homework',
                ),
                onChanged: (value) {
                  content = value;
                },
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              if (content.isEmpty) return;

              await ref.collection('todos').add({
                'content': content,
                'isDone': false,
                'created_at': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

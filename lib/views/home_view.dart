import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highput/models/todo_board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:highput/views/task_view.dart';
import 'package:highput/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xfff6f6f6),
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 24.0,
            left: 24.0,
            right: 24.0,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<TodoBoard>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('boards')
                            .orderBy('created_at', descending: true)
                            .withConverter(
                              fromFirestore: (snapshot, _) =>
                                  TodoBoard.fromJson(snapshot.data()!),
                              toFirestore: (TodoBoard model, _) =>
                                  model.toJson(),
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final cards = <TaskCard>[];

                          if(snapshot.data!.docs.length == 0) {
                            return Center(
                              child: Text('No todo boards'),
                            );
                          }

                          snapshot.data!.docs.forEach((doc) {
                            final board = doc.data();

                            cards.add(
                              TaskCard(
                                board: board,
                                ref: doc.reference,
                              ),
                            );
                          });

                          return ScrollConfiguration(
                            behavior: ScrollBehavior(),
                            child: ListView(
                              children: cards,
                            ),
                          );
                        }),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskView(null, null),
                        ),
                      );
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

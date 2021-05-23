import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highput/models/reminder.dart';
import 'package:highput/models/todo_board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:highput/services/notifications.dart';
import 'package:highput/views/task_view.dart';
import 'package:highput/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

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
                    child: FutureBuilder<NotificationSettings>(
                      future: getNotificationSettings(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final settings = snapshot.data;

                        if (settings!.authorizationStatus !=
                            AuthorizationStatus.authorized) {
                          return Center(
                            child: Text('No permission given'),
                          );
                        }

                        return StreamBuilder<QuerySnapshot<Reminder>>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('reminders')
                              .orderBy('time')
                              .withConverter(
                                fromFirestore: (snapshot, _) =>
                                    Reminder.fromJson(snapshot.data()!),
                                toFirestore: (Reminder model, _) =>
                                    model.toJson(),
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final cards = <ReminderCard>[];

                            if (snapshot.data!.docs.length == 0) {
                              return Center(
                                child: Text('No reminders'),
                              );
                            }

                            snapshot.data!.docs.forEach((doc) {
                              final reminder = doc.data();

                              cards.add(
                                ReminderCard(reminder.title, reminder.time, doc.reference),
                              );
                            });

                            return ScrollConfiguration(
                              behavior: ScrollBehavior(),
                              child: ListView(
                                children: cards,
                              ),
                            );
                          },
                        );
                      },
                    ),
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
                      newReminder(context);
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

Future<void> newReminder(BuildContext context) {
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
                  labelText: 'Reminder text',
                  hintText: 'Drink water',
                ),
                onChanged: (value) {
                  content = value;
                },
              ),
            ),
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
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('reminders')
                  .add({
                'title': content,
                'time': DateFormat('HH:mm').format(DateTime.now().toLocal()),
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

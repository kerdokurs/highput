import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const firestore = admin.firestore();

export const newUser = functions
  .region('europe-west1')
  .auth.user()
  .onCreate(async (user) => {
    const { displayName, email, uid } = user;

    await firestore.collection('users').doc(uid).set(
      {
        uid,
        email,
        displayName,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    const board = firestore
      .collection('users')
      .doc(uid)
      .collection('boards')
      .doc();
    await board.set({
      title: 'Welcome!',
      description: `Welcome to Highput, ${displayName || email}!`,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    [
      {
        content: 'Sign in',
        isDone: true,
      },
      {
        content: 'Add a new todo',
        isDone: false,
      },
      {
        content: 'Create a task board',
        isDone: false,
      },
    ].forEach(async (data) => {
      await board.collection('todos').add({
        ...data,
        created_at: admin.firestore.FieldValue.serverTimestamp(),
      });
    });
  });

export const timer = functions
  .region('europe-west1')
  .pubsub.schedule('* * * * *')
  .timeZone('Europe/Tallinn')
  .onRun(async (context) => {
    const messaging = admin.messaging();

    const pad = (num: number) => String(num).padStart(2, '0');

    const now = admin.firestore.Timestamp.now();
    const date = now.toDate();

    const hours = pad(date.getHours() + 3);
    const minutes = pad(date.getMinutes());
    const time = `${hours}:${minutes}`;

    functions.logger.debug(`Time ${time}`);

    const jobs: Promise<any>[] = [];

    const usersDoc = await firestore.collection('users').get();
    usersDoc.docs.forEach(async (doc) => {
      const data = doc.data();
      const { displayName, token } = data;

      if (!token) return;

      const reminders = await doc.ref
        .collection('reminders')
        .where('time', '==', time)
        .get();

      reminders.docs.forEach((reminder) => {
        const reminderData = reminder.data();
        const { title } = reminderData;

        if (!title) return;

        const job = messaging
          .sendToDevice(token, {
            notification: {
              title: 'Reminder',
              body: title,
            },
          })
          .then(() =>
            functions.logger.info('Reminder sent to', displayName || token)
          )
          .catch((e) =>
            functions.logger.error(
              'Error occurred while sending to',
              displayName || token,
              e
            )
          );

        jobs.push(job);
      });
    });

    await Promise.all(jobs);
  });

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

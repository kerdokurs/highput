import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:highput/models/auth_response.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<AuthResponse> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    return AuthResponse(false, 'Signed in!');
  } on FirebaseAuthException catch (e) {
    return AuthResponse(false, e.message ?? 'Error signing in');
  }
}

Future<AuthResponse> signInWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return AuthResponse(false, 'Signed in!');
  } on FirebaseAuthException catch (e) {
    return AuthResponse(true, e.message ?? 'Error signing in');
  }
}

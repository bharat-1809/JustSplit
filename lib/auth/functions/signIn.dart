import 'package:firebase_auth/firebase_auth.dart';

Future<void> signInWithEmailAndPass({String email, String password}) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

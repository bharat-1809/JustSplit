import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<void> signUpWithEmailAndPass(
    {@required String email, @required String password}) async {
  final _authResult =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  await _authResult.user.sendEmailVerification();
}

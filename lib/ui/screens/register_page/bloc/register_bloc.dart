import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/auth/functions/signUp.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterButtonClicked) {
      try {
        yield (RegisterInProgress());
        await signUpWithEmailAndPass(
            email: event.email, password: event.password);
        await FirebaseAnalytics().logSignUp(signUpMethod: "email_pass");
        yield (RegisterSuccess());
      } catch (e) {
        yield (RegisterFailed(message: e.toString()));
      }
    } else if (event is GoogleSignUpClicked) {
      try {
        yield (RegisterInProgress());

        final _googleSignIn = GoogleSignIn();
        final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication _googleAuth =
            await _googleUser.authentication;
        final AuthCredential _authCredentials =
            GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken,
          accessToken: _googleAuth.accessToken,
        );

        await FirebaseAuth.instance.signInWithCredential(_authCredentials);
        await FirebaseAnalytics().logSignUp(signUpMethod: "google_signup");

        yield (RegisterSuccess());
      } on PlatformException catch (e) {
        yield (RegisterFailed(message: "Error: ${e.message}"));
      } on AuthException catch (e) {
        yield (RegisterFailed(message: "Error: ${e.message}"));
      } on TimeoutException catch (e) {
        yield (RegisterFailed(message: "Timeout: ${e.message}"));
      } catch (e) {
        yield (RegisterFailed(message: e.toString()));
      }
    }
  }
}

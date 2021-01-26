import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/sdk/functions/messaging_functions.dart';
import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:contri_app/auth/functions/signIn.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    try {
      if (event is LoginButtonPressed) {
        yield (LoginInProgress());

        await signInWithEmailAndPass(
            email: event.email, password: event.password);

        await FirebaseAnalytics().logLogin(loginMethod: "email_pass");

        logger.i("Checking whther user email is verified");
        final _currentUser = await FirebaseAuth.instance.currentUser();

        if (_currentUser.isEmailVerified) {
          logger.i("Initializing sdk");

          await initializeSdk;
          logger.i("sdk Initialized");
          logger.i("Checking whether profile is complete");

          if (globalUser.registrationStatus !=
              "${registrationStatus.registered}") {
            logger.i("User Profile Incomplete");

            yield (LoginNeedsProfileComplete());
          } else {
            logger.i("All Checks Passed");

            final _prefs = await SharedPreferences.getInstance();
            final _notificationStatus = _prefs.getBool('showNotifications');
            logger.v("Show Notifications: $_notificationStatus");

            if (_notificationStatus == null || _notificationStatus == true) {
              await NotificationHandler.uploadDeviceToken(
                  userId: globalUser.id);
            }

            await initializeComments;
            yield (LoginSuccess());
          }
        } else {
          yield (LoginNeedsVerification());
        }
      } else if (event is LoginWithGoogle) {
        yield (LoginInProgress());

        final _googleSignIn = GoogleSignIn();
        final _googleSigninAccount = await _googleSignIn.signIn();
        final _googleAuth = await _googleSigninAccount.authentication;
        final _authCredentials = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken,
          accessToken: _googleAuth.accessToken,
        );

        await FirebaseAuth.instance.signInWithCredential(_authCredentials);

        await FirebaseAnalytics().logLogin(loginMethod: "google_signin");

        final _currentUser = await FirebaseAuth.instance.currentUser();
        logger.i("Checking Whether Profile is Complete");

        final _querySnapshot = await Firestore.instance
            .collection('users')
            .where('email', isEqualTo: _currentUser.email)
            .getDocuments();

        final _doc = _querySnapshot.documents;

        if (_doc.length == 0) {
          logger.i("User Profile Incomplete");

          yield (LoginNeedsProfileComplete());
        } else {
          logger.i("All Checks Passed");

          logger.i("Initializing sdk");
          await initializeSdk;

          final _prefs = await SharedPreferences.getInstance();
          final _notificationStatus = _prefs.getBool('showNotifications');
          logger.v("Show Notifications: $_notificationStatus");

          if (_notificationStatus == null || _notificationStatus == true) {
            await NotificationHandler.uploadDeviceToken(userId: globalUser.id);
          }

          await initializeComments;

          yield (LoginSuccess());
        }
      } else if (event is ForgetPassword) {
        yield (LoginInProgress());

        await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
        logger.d("Password Reset Email Sent");

        yield (ForgetPasswordSuccess());
      }
    } on PlatformException catch (e) {
      yield (LoginFailure(message: "Error: ${e.message}"));
    } on AuthException catch (e) {
      yield (LoginFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (LoginFailure(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (LoginFailure(message: e.toString()));
    }
  }
}

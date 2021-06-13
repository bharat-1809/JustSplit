import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/sdk/functions/messaging_functions.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthUnInitialized());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    try {
      if (event is AppStarted) {
        yield (AuthInProgress());
        final _currentUser = await FirebaseAuth.instance.currentUser();
        if (_currentUser != null) {
          logger.i("Checking whether user is verified");
          if (_currentUser.isEmailVerified) {
            logger.i("Checking Whether Profile is Complete");

            final _querySnapshot = await Firestore.instance
                .collection('users')
                .where('email', isEqualTo: _currentUser.email)
                .getDocuments();

            final _doc = _querySnapshot.documents;

            if (_doc.length == 0) {
              logger.i("Profile is incomplete");

              yield (AuthNeedsProfileComplete());
            } else {
              logger.i("All Checks Completed");

              logger.i("Initializing Sdk");
              await initializeSdk;
              logger.i("Sdk Initialized");

              final _prefs = await SharedPreferences.getInstance();
              final _notificationStatus = _prefs.getBool('showNotifications');
              logger.v("Show Notifications: $_notificationStatus");

              if (_notificationStatus == null || _notificationStatus == true) {
                NotificationHandler.uploadDeviceToken(userId: globalUser.id);
              }

              initializeComments;
              logger.i("Comments Initialized");

              yield (AuthAuthenticated());
            }
          } else {
            yield (AuthNeedsVerification());
          }
        } else {
          yield (AuthUnAuthenticated());
        }
      } else if (event is JustLoggedOut) {
        await NotificationHandler.clearDeviceToken(userId: globalUser.id);

        yield (AuthInProgress());
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();

        await disposeSdk;
        yield (AuthUnAuthenticated(justLoggedOut: true));
      }
    } on PlatformException catch (e) {
      yield (AuthFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (AuthFailure(message: "Timeout: ${e.message}"));
    } on AuthException catch (e) {
      yield (AuthFailure(message: "Error: ${e.message}"));
    } catch (e) {
      yield (AuthFailure(message: e.toString()));
    }
  }
}

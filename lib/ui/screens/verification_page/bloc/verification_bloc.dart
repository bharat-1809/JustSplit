import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/global/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationInitial());

  @override
  Stream<VerificationState> mapEventToState(
    VerificationEvent event,
  ) async* {
    try {
      if (event is VerificationInitiated) {
        yield (VerificationInProgress());

        logger.wtf("Verification Started");

        await FirebaseAuth.instance.currentUser().then((_cUser) async {
          await _cUser.reload();
        });

        final _user = await FirebaseAuth.instance.currentUser();

        bool _isEmailVerified = _user.isEmailVerified;

        logger.wtf("Email Verified: $_isEmailVerified");
        if (_isEmailVerified) {
          yield (VerificationSuccess());
        } else if (event.isFirstTime) {
          yield (VerificationFailed(
            message: "Click on the link sent to verify your email id",
          ));
        } else {
          yield (VerificationFailed(
            message:
                "Verification Failed. Please Click on the link sent to your email id",
          ));
        }
      } else if (event is ResendVerificationMail) {
        yield (VerificationInProgress());
        final _user = await FirebaseAuth.instance.currentUser();
        await _user.sendEmailVerification();
        yield (ResendVerification());
      }
    } on PlatformException catch (e) {
      yield (VerificationFailed(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (VerificationFailed(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (VerificationFailed(message: e.toString()));
    }
  }
}

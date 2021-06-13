import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/sdk/functions/messaging_functions.dart';
import 'package:contri_app/sdk/functions/user_functions.dart';
import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'profilereg_event.dart';
part 'profilereg_state.dart';

class ProfileregBloc extends Bloc<ProfileregEvent, ProfileregState> {
  ProfileregBloc() : super(ProfileregInitial());

  @override
  Stream<ProfileregState> mapEventToState(
    ProfileregEvent event,
  ) async* {
    if (event is ProfileRegClicked) {
      try {
        yield (ProfileRegInProgress());

        final _fbuser = await FirebaseAuth.instance.currentUser();
        final User _user = User(
          firstName: event.firstName,
          lastName: event.lastName,
          defaultCurrency: event.defaultCurrency,
          phoneNumber: event.phoneNumber,
          pictureUrl: event.photoUrl,
          email: _fbuser.email,
        );

        await UserFunctions.createUser(_user);
        await initializeSdk;
        await initializeComments;
        await NotificationHandler.uploadDeviceToken(userId: globalUser.id);

        yield (ProfileRegSuccess());
      } on PlatformException catch (e) {
        yield (ProfileRegFailed(message: "Error: ${e.message}"));
      } on TimeoutException catch (e) {
        yield (ProfileRegFailed(message: "Timeout: ${e.message}"));
      } catch (e) {
        yield (ProfileRegFailed(message: e.toString()));
      }
    }
  }
}

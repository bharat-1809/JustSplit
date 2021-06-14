import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/sdk/functions/user_functions.dart';
import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfilePageLoaded());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    try {
      if (event is EditProfile) {
        yield (EditableProfilePage());
      } else if (event is ProfileSaved) {
        yield (ProfilePageLoading());
        if (event.firstName == globalUser.firstName &&
            event.lastName == globalUser.lastName &&
            event.phoneNumber == globalUser.phoneNumber &&
            event.defaultCurrency == globalUser.defaultCurrency &&
            event.pictureUrl == globalUser.pictureUrl)
          yield (ProfileChangeSuccess());
        else {
          final _user = User(
            id: globalUser.id,
            email: globalUser.email,
            registrationStatus: globalUser.registrationStatus,
            defaultCurrency: event.defaultCurrency,
            firstName: event.firstName,
            lastName: event.lastName,
            pictureUrl: event.pictureUrl,
            phoneNumber: event.phoneNumber,
          );
          UserFunctions.updateUserDetails(_user);
          setGlobalUser = _user;
          yield (ProfileChangeSuccess());
        }
      }
    } on PlatformException catch (e) {
      yield (ProfileChangeFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (ProfileChangeFailure(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (ProfileChangeFailure(message: e.toString()));
    }
  }
}

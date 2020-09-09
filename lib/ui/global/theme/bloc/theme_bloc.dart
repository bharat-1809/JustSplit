import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:contri_app/ui/global/theme/app_themes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(appThemeData: appThemeData[AppTheme.Light]));

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt('theme_id', event.appTheme.index);
      yield ThemeState(appThemeData: appThemeData[event.appTheme]);
    }
  }
}

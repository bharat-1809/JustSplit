import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/global/logger.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeFriends());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is FriendsPageSelected)
      yield (HomeFriends());
    else if (event is GroupsPageRequested)
      yield (HomeGroups());
    else if (event is AddExpensePageSelected)
      yield (HomeAddExpense());
    else if (event is AllExpensesPageSelected)
      yield (HomeAllExpenses());
    else if (event is NotesPageSelected) yield (HomeNotes());
  }
}

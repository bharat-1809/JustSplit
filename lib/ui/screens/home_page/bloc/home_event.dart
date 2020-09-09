part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];

  factory HomeEvent.fromIndex(int index) {
    HomeEvent event;
    switch (index) {
      case 0:
        event = FriendsPageSelected();
        break;
      case 1:
        event = GroupsPageRequested();
        break;
      case 2:
        event = AddExpensePageSelected();
        break;
      case 3:
        event = AllExpensesPageSelected();
        break;
      case 4:
        event = NotesPageSelected();
        break;
      default:
        logger.wtf("HomeEvent.fromIndex: index $index is not valid");
    }
    return event;
  }
}

class FriendsPageSelected extends HomeEvent {}

class GroupsPageRequested extends HomeEvent {}

class AddExpensePageSelected extends HomeEvent {}

class AllExpensesPageSelected extends HomeEvent {}

class NotesPageSelected extends HomeEvent {}

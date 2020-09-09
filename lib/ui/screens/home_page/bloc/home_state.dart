part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final int index = -1;

  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeFriends extends HomeState {
  @override
  int get index => 0;
}

class HomeGroups extends HomeState {
  @override
  int get index => 1;
}

class HomeAddExpense extends HomeState {
  @override
  int get index => 2;
}

class HomeAllExpenses extends HomeState {
  @override
  int get index => 3;
}

class HomeNotes extends HomeState {
  @override
  int get index => 4;
}

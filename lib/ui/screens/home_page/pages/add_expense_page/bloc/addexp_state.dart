part of 'addexp_bloc.dart';

abstract class AddexpState extends Equatable {
  const AddexpState();

  @override
  List<Object> get props => [];
}

class AddExpInitial extends AddexpState {}

class RequestingAddExpMainPage extends AddexpState {}

class AddexpFailure extends AddexpState {
  final String message;
  AddexpFailure({this.message});

  @override
  List<Object> get props => [message];
}

class AddExpSuccess extends AddexpState {}

class AddExpInProgress extends AddexpState {}

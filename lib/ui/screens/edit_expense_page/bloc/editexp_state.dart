part of 'editexp_bloc.dart';

abstract class EditexpState extends Equatable {
  const EditexpState();

  @override
  List<Object> get props => [];
}

class EditexpInitial extends EditexpState {}

class EditExpSuccess extends EditexpState {}

class EditExpLoading extends EditexpState {}

class EditExpFailed extends EditexpState {
  final String message;
  EditExpFailed({this.message});

  @override
  List<Object> get props => [message];
}

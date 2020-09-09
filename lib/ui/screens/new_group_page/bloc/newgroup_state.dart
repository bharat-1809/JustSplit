part of 'newgroup_bloc.dart';

abstract class NewgroupState extends Equatable {
  const NewgroupState();
  @override
  List<Object> get props => [];
}

class NewgroupInitial extends NewgroupState {}

class NewGroupLoading extends NewgroupState {}

class NewGroupFailure extends NewgroupState {
  final String message;
  NewGroupFailure({this.message});

  @override
  List<Object> get props => [message];
}

class NewGroupSuccess extends NewgroupState {}

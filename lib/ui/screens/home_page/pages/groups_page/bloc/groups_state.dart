part of 'groups_bloc.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();

  @override
  List<Object> get props => [];
}

class GroupsInitial extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<CustomTile> groupsList;
  GroupsLoaded({@required this.groupsList}) : assert(groupsList != null);

  @override
  List<Object> get props => [groupsList];
}

class GroupsFailure extends GroupsState {
  final String message;
  GroupsFailure({this.message});

  @override
  List<Object> get props => [message];
}

part of 'groups_bloc.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();

  @override
  List<Object> get props => [];
}

class GroupsInitial extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<CustomTile> groupsList;
  final List<CustomTile> settledGroupsList;
  GroupsLoaded({
    @required this.groupsList,
    @required this.settledGroupsList,
  }) : assert(groupsList != null, settledGroupsList != null);

  @override
  List<Object> get props => [groupsList, settledGroupsList];
}

class GroupsFailure extends GroupsState {
  final String message;
  GroupsFailure({this.message});

  @override
  List<Object> get props => [message];
}

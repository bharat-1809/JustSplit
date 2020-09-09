part of 'groupname_bloc.dart';

abstract class GroupnameEvent extends Equatable {
  const GroupnameEvent();
}

class GroupNameChanged extends GroupnameEvent {
  final String groupId;
  GroupNameChanged({@required this.groupId});

  @override
  List<Object> get props => [groupId];
}

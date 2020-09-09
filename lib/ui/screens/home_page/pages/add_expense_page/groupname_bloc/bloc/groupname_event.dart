part of 'groupname_bloc.dart';

abstract class GroupnameEvent extends Equatable {
  const GroupnameEvent();
}

class UpdateGroupName extends GroupnameEvent {
  final String newName;
  UpdateGroupName({@required this.newName}) : assert(newName != null);

  @override
  List<Object> get props => [newName];
}

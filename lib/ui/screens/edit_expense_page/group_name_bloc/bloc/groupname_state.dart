part of 'groupname_bloc.dart';

class GroupnameState extends Equatable {
  final String groupName;
  GroupnameState({@required this.groupName});
  @override
  List<Object> get props => [groupName];
}

part of 'newgroup_bloc.dart';

abstract class NewgroupEvent extends Equatable {
  const NewgroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupButtonClicked extends NewgroupEvent {
  final String groupName;
  final List<String> members;
  final String pictureUrl;
  CreateGroupButtonClicked(
      {@required this.groupName,
      @required this.members,
      @required this.pictureUrl})
      : assert(groupName != null),
        assert(pictureUrl != null),
        assert(members != null);

  @override
  List<Object> get props => [groupName, members, pictureUrl];
}

class ErrorSelectingFriend extends NewgroupEvent {}

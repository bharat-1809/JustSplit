part of 'detailexp_bloc.dart';

abstract class DetailexpEvent extends Equatable {
  const DetailexpEvent();

  @override
  List<Object> get props => [];
}

class DetailExpPageRequested extends DetailexpEvent {
  final ScreenArguments argObject;
  final bool isGroupExpDetail;
  DetailExpPageRequested(
      {@required this.argObject, @required this.isGroupExpDetail})
      : assert(argObject != null),
        assert(isGroupExpDetail != null);

  @override
  List<Object> get props => [argObject, isGroupExpDetail];
}

class SettleUpExpenses extends DetailexpEvent {
  final String userId;
  SettleUpExpenses({@required this.userId}) : assert(userId != null);

  @override
  List<Object> get props => [userId];
}

class DeleteGroup extends DetailexpEvent {
  final String groupId;
  DeleteGroup({@required this.groupId}) : assert(groupId != null);

  @override
  List<Object> get props => [groupId];
}

class DeleteFriend extends DetailexpEvent {
  final String friendId;
  DeleteFriend({@required this.friendId}) : assert(friendId != null);

  @override
  List<Object> get props => [friendId];
}

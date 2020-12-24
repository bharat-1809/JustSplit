part of 'friends_bloc.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {}

class FriendsPageLoaded extends FriendsState {
  final List<CustomTile> friendsList;
  FriendsPageLoaded({@required this.friendsList}) : assert(friendsList != null);

  @override
  List<Object> get props => [friendsList];
}

class FriendsPageError extends FriendsState {
  final String message;
  FriendsPageError({this.message});

  @override
  List<Object> get props => [message];
}

class FriendsPageLoading extends FriendsState {}

class FriendsPageSuccess extends FriendsState {
  final String firstName;
  final String phoneNumber;
  FriendsPageSuccess({@required this.firstName, @required this.phoneNumber})
      : assert(firstName != null),
        assert(phoneNumber != null);

  @override
  List<Object> get props => [firstName, phoneNumber];
}

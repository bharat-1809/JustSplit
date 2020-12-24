part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class FriendsPageRequested extends FriendsEvent {}

class AddNewFriend extends FriendsEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String defaultCurency;
  AddNewFriend(
      {@required this.firstName,
      @required this.lastName,
      @required this.defaultCurency,
      @required this.phoneNumber})
      : assert(firstName != null),
        assert(lastName != null),
        assert(phoneNumber != null),
        assert(defaultCurency != null);

  @override
  List<Object> get props => [firstName, lastName, phoneNumber, defaultCurency];
}

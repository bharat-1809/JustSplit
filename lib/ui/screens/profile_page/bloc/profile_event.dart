part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class EditProfile extends ProfileEvent {}

class ProfileSaved extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String defaultCurrency;
  final String pictureUrl;
  ProfileSaved(
      {@required this.firstName,
      @required this.lastName,
      @required this.defaultCurrency,
      @required this.phoneNumber,
      @required this.pictureUrl})
      : assert(firstName != null),
        assert(lastName != null),
        assert(pictureUrl != null),
        assert(defaultCurrency != null),
        assert(phoneNumber != null);

  @override
  List<Object> get props =>
      [firstName, lastName, defaultCurrency, phoneNumber, pictureUrl];
}

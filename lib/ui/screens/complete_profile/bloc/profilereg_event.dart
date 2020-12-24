part of 'profilereg_bloc.dart';

abstract class ProfileregEvent extends Equatable {
  const ProfileregEvent();

  @override
  List<Object> get props => [];
}

class ProfileRegClicked extends ProfileregEvent {
  final String firstName;
  final String lastName;
  final String photoUrl;
  final String phoneNumber;
  final String defaultCurrency;
  ProfileRegClicked(
      {@required this.firstName,
      @required this.lastName,
      @required this.photoUrl,
      @required this.phoneNumber,
      @required this.defaultCurrency})
      : assert(firstName != null),
        assert(lastName != null),
        assert(phoneNumber != null),
        assert(photoUrl != null);

  @override
  List<Object> get props =>
      [firstName, lastName, phoneNumber, defaultCurrency, photoUrl];
}

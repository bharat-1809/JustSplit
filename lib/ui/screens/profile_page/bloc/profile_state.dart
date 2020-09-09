part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileChangeSuccess extends ProfileState {}

class ProfileChangeFailure extends ProfileState {
  final String message;
  ProfileChangeFailure({this.message});

  @override
  List<Object> get props => [message];
}

class ProfilePageLoading extends ProfileState {}

class EditableProfilePage extends ProfileState {}

class ProfilePageLoaded extends ProfileState {}

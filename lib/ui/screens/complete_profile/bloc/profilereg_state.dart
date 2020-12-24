part of 'profilereg_bloc.dart';

abstract class ProfileregState extends Equatable {
  const ProfileregState();

  @override
  List<Object> get props => [];
}

class ProfileregInitial extends ProfileregState {}

class ProfileRegInProgress extends ProfileregState {}

class ProfileRegSuccess extends ProfileregState {}

class ProfileRegFailed extends ProfileregState {
  final String message;
  ProfileRegFailed({this.message});

  @override
  List<Object> get props => [message];
}

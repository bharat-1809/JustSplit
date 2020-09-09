part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthUnInitialized extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnAuthenticated extends AuthState {
  final bool justLoggedOut;
  AuthUnAuthenticated({this.justLoggedOut = false});

  @override
  List<Object> get props => [justLoggedOut];
}

class AuthInProgress extends AuthState {}

class AuthNeedsVerification extends AuthState {}

class AuthNeedsProfileComplete extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({this.message});

  @override
  List<Object> get props => [message];
}

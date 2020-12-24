part of 'verification_bloc.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object> get props => [];
}

class VerificationInitial extends VerificationState {}

class VerificationInProgress extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class ResendVerification extends VerificationState {}

class VerificationFailed extends VerificationState {
  final String message;
  VerificationFailed({this.message});

  @override
  List<Object> get props => [message];
}

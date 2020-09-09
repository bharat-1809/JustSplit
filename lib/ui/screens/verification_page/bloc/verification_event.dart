part of 'verification_bloc.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object> get props => [];
}

class VerificationInitiated extends VerificationEvent {
  final bool isFirstTime;
  VerificationInitiated({this.isFirstTime = false});

  @override
  List<Object> get props => [];
}

class ResendVerificationMail extends VerificationEvent {}

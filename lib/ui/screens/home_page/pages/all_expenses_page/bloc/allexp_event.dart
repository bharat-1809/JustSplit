part of 'allexp_bloc.dart';

abstract class AllexpEvent extends Equatable {
  const AllexpEvent();

  @override
  List<Object> get props => [];
}

class AllexpRequested extends AllexpEvent {}

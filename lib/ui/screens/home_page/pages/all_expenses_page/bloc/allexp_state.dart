part of 'allexp_bloc.dart';

abstract class AllexpState extends Equatable {
  const AllexpState();
  @override
  List<Object> get props => [];
}

class AllexpInitial extends AllexpState {}

class AllexpLoaded extends AllexpState {
  final List<CustomTile> expensesList;
  AllexpLoaded({@required this.expensesList}) : assert(expensesList != null);

  @override
  List<Object> get props => [expensesList];
}

class AllexpFailure extends AllexpState {
  final String message;
  AllexpFailure({this.message});

  @override
  List<Object> get props => [message];
}

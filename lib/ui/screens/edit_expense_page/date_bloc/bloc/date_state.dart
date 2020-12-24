part of 'date_bloc.dart';

class DateState extends Equatable {
  final DateTime dateTime;
  DateState({@required this.dateTime}) : assert(dateTime != null);
  @override
  List<Object> get props => [dateTime];
}

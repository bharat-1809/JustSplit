part of 'date_bloc.dart';

abstract class DateEvent extends Equatable {
  const DateEvent();

  @override
  List<Object> get props => [];
}

class DateChanged extends DateEvent {
  final DateTime dateTime;
  DateChanged({@required this.dateTime}) : assert(dateTime != null);

  @override
  List<Object> get props => [dateTime];
}

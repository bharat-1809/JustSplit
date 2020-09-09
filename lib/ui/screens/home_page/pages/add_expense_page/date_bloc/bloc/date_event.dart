part of 'date_bloc.dart';

abstract class DateEvent extends Equatable {
  const DateEvent();

  @override
  List<Object> get props => [];
}

class DateChanged extends DateEvent {
  final DateTime newDateTime;
  DateChanged({@required this.newDateTime}) : assert(newDateTime != null);

  @override
  List<Object> get props => [newDateTime];
}

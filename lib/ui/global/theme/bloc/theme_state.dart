part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData appThemeData;
  const ThemeState({@required this.appThemeData})
      : assert(appThemeData != null);

  @override
  List<Object> get props => [appThemeData];
}

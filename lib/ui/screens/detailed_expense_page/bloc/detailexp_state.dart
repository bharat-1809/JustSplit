part of 'detailexp_bloc.dart';

class DetailexpState extends Equatable {
  const DetailexpState();
  @override
  List<Object> get props => [];
}

class DetailexpInitialState extends DetailexpState {
  final String id;
  final String name;
  final String phoneNumber;
  final bool isGroupExpDetail;
  final List<CustomTile> widgetList;
  final double netBalance;
  final String pictureUrl;
  DetailexpInitialState(
      {@required this.name,
      @required this.pictureUrl,
      this.phoneNumber,
      this.id,
      @required this.isGroupExpDetail,
      @required this.widgetList,
      @required this.netBalance})
      : assert(name != null),
        assert(pictureUrl != null),
        assert(netBalance != null),
        assert(isGroupExpDetail != null),
        assert(widgetList != null);

  @override
  List<Object> get props =>
      [name, phoneNumber, netBalance, widgetList, id, pictureUrl];
}

class DetailExpLoading extends DetailexpState {}

class DetailExpSuccess extends DetailexpState {}

class DetailExpFailure extends DetailexpState {
  final String message;
  DetailExpFailure({this.message});

  @override
  List<Object> get props => [message];
}

class DeleteGroupSuccess extends DetailexpState {}

class DeleteFriendSuccess extends DetailexpState {}

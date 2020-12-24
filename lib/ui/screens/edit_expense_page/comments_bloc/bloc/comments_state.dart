part of 'comments_bloc.dart';

class CommentsState extends Equatable {
  final String comment;
  CommentsState({@required this.comment}) : assert(comment != null);
  @override
  List<Object> get props => [comment];
}

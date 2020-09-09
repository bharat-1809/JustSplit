part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();
}

class CommentAdded extends CommentsEvent {
  final String comment;
  CommentAdded({@required this.comment}) : assert(comment != null);

  @override
  List<Object> get props => [comment];
}

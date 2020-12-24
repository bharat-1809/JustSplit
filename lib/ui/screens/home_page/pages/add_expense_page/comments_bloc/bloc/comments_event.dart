part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class AddNewComment extends CommentsEvent {
  final String newComment;
  AddNewComment({@required this.newComment}) : assert(newComment != null);

  @override
  List<Object> get props => [newComment];
}

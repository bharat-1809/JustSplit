part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class CommentsRequested extends NotesEvent {}

class AddComment extends NotesEvent {
  final String comment;
  AddComment({@required this.comment}) : assert(comment != null);

  @override
  List<Object> get props => [comment];
}

class DeleteComment extends NotesEvent {
  final String commentId;
  DeleteComment({@required this.commentId}) : assert(commentId != null);

  @override
  List<Object> get props => [commentId];
}

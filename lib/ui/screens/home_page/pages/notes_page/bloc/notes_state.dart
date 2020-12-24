part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState();
  @override
  List<Object> get props => [];
}

class NotesLoaded extends NotesState {
  final List<CommentTile> commentList;
  NotesLoaded({@required this.commentList}) : assert(commentList != null);

  @override
  List<Object> get props => [commentList];
}

class NotesLoading extends NotesState {}

class NotesSuccess extends NotesState {}

class NotesFailure extends NotesState {
  final String message;
  NotesFailure({this.message});

  @override
  List<Object> get props => [message];
}

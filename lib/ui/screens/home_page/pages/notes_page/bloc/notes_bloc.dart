import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contri_app/sdk/functions/comment_functions.dart';
import 'package:contri_app/sdk/models/comment_model/comment_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/comment_tile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesLoaded(commentList: []));

  @override
  Stream<NotesState> mapEventToState(
    NotesEvent event,
  ) async* {
    try {
      if (event is CommentsRequested) {
        final _comments = getCurrentComments;
        _comments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        List<CommentTile> _commentsTileList = [];
        for (var _com in _comments.reversed.toList()) {
          _commentsTileList.add(
            CommentTile(
              commentId: _com.id,
              comment: _com.comment,
              dateTime: _com.dateTime,
            ),
          );
        }
        yield (NotesLoaded(commentList: _commentsTileList));
      }
      if (event is AddComment) {
        yield (NotesLoading());
        final _comment = Comment(
          comment: event.comment,
          dateTime: DateTime.now(),
        );
        CommentFunctions.createComment(_comment);
        getCurrentComments.add(_comment);
        yield (NotesSuccess());
      }
      if (event is DeleteComment) {
        yield (NotesLoading());
        CommentFunctions.deleteComment(event.commentId);
        getCurrentComments.removeWhere((e) => e.id == event.commentId);
        yield (NotesSuccess());
      }
    } on PlatformException catch (e) {
      yield (NotesFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (NotesFailure(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (NotesFailure(message: e.toString()));
    }
  }
}

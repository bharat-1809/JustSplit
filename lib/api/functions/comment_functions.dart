import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/api/models/comment_model.dart';
import 'package:contri_app/global/global_helpers.dart';

class CommentFunctions {
  static final _firestore = Firestore.instance;

  /// Creates a new comment. No need to provide [id] parameter
  static Future<void> createComment(Comment comment) async {
    final _docId = _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('comments')
        .document()
        .documentID;

    comment.id = _docId;
    final _commentMap = comment.toJson();
    _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('comments')
        .document(_docId)
        .setData(
          _commentMap,
          merge: true,
        );
  }

  /// Get all comments for the current user
  static Future<List<Comment>> getComments() async {
    final _queryList = await _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('comments')
        .getDocuments();

    final _docList = _queryList.documents;
    List<Comment> _comments = [];
    for (var _doc in _docList) {
      final Comment _comment = Comment.fromJson(_doc.data);
      _comments.add(_comment);
    }
    return _comments;
  }

  /// Delete the comment with given commentId
  static Future<void> deleteComment(String commentId) async {
    await _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('comments')
        .document(commentId)
        .delete();
  }
}

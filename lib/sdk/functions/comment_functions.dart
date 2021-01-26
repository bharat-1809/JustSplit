import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/sdk/models/comment_model/comment_model.dart';
import 'package:contri_app/global/global_helpers.dart';

class CommentFunctions {
  static final _firestore = Firestore.instance;

  /// Creates a new [Comment]. No need to provide [id] parameter
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

  /// Get all [Comment]s for the current [User]
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

  /// Delete the [Comment] with given commentId
  static Future<void> deleteComment(String commentId) async {
    await _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('comments')
        .document(commentId)
        .delete();
  }
}

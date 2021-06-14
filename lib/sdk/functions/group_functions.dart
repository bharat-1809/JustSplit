import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/sdk/functions/expenses_functions.dart';
import 'package:contri_app/sdk/models/group_model/group_model.dart';
import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:contri_app/global/global_helpers.dart';

class GroupFunctions {
  static final _firestore = Firestore.instance;

  /// Get a [Group] of current [User] by its id
  static Future<Group> getGroupById({String id}) async {
    final _queryList = await _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('groups')
        .where('id', isEqualTo: id)
        .getDocuments();

    final _docList = _queryList.documents;
    final _data = _docList[0].data;
    final _group = Group.fromJson(_data);
    return _group;
  }

  /// Get all [Groups] of current user
  static Future<List<Group>> getGroups([DocumentReference documentReference]) async {
    List<DocumentSnapshot> _docList;
    if (documentReference == null) {
      final _queryList = await _firestore
          .collection('users')
          .document(globalUser.id)
          .collection('groups')
          .getDocuments();
      _docList = _queryList.documents;
    } else {
      final _querylist = await documentReference.collection('groups').getDocuments();
      _docList = _querylist.documents;
    }

    List<Group> _groups = [];
    for (var _group in _docList) {
      final Group _grp = Group.fromJson(_group.data);
      _groups.add(_grp);
    }
    return _groups;
  }

  /// Creates a [Group]
  static Future<void> createGroup({Group group}) async {
    final _docId = _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('groups')
        .document()
        .documentID;

    group.id = _docId;

    for (var _user in group.members) {
      await _firestore
          .collection('users')
          .document(_user.id)
          .collection('groups')
          .document(_docId)
          .setData(
            group.toJson(),
            merge: true,
          );
    }
  }

  /// Updates the [Group] with [id] as [groupId], with the provided [Group].
  /// [name] and [members] property must be provided otherwise they will be
  /// overwritten by [null] values
  /// '
  static Future<void> updateGroup({Group group}) async {
    /// [id] and [pictureUrl] cannot be updated so original values used
    /// Update the [updatedAt] field by latest time
    /// 'updatedAt': Timestamp.now().toString(),

    for (var _user in group.members) {
      await _firestore
          .collection('users')
          .document(_user.id)
          .collection('groups')
          .document(group.id)
          .setData(
            group.toJson(),
            merge: true,
          );
    }
  }

  /// Adds the provided [User] to the [Group] with the given [groupId].
  /// This function does not updates the group-expenses after adding the user
  static Future<void> addUserToGroup({String groupId, User newUser}) async {
    final _group = await getGroupById(id: groupId);
    _group.members.add(newUser);
    await updateGroup(group: _group);
  }

  /// Removes the [User] with given [userId] from the [Group] with
  /// given [groupId].
  /// This function does not update the group-expenses after removing the user
  static Future<void> removeUserFromGroup({String groupId, String userId}) async {
    final _group = await getGroupById(id: groupId);
    _group.members.removeWhere((user) {
      return user.id == userId;
    });
    await updateGroup(group: _group);
  }

  /// Deletes a [Group] along with its [Expense]s for the current member
  static Future<void> deleteGroup({String id}) async {
    final _expenses = getCurrentExpenses;
    for (var exp in _expenses) {
      if (exp.groupId == id) {
        await ExpensesFunctions.deleteExpense(id: exp.id);
      }
    }

    final _d = await _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('groups')
        .getDocuments();

    final _e = _d.documents.firstWhere(
      (element) => element.documentID == id,
      orElse: () => null,
    );
    await _e.reference.delete();
  }
}

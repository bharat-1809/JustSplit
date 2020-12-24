import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/api/models/group_model.dart';
import 'package:contri_app/api/models/user_model.dart';
import 'package:contri_app/global/global_helpers.dart';

class GroupFunctions {
  static final _firestore = Firestore.instance;

  /// Get a group of current user by its id
  static Future<Group> getGroupById({String id}) async {
    final _queryList = await _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('groups')
        .where('id', isEqualTo: id)
        .getDocuments();
    final _docList = _queryList.documents;
    final _data = _docList[0].data;
    List<User> _membersList = [];
    for (var _user in _data['members']) {
      _membersList.add(
        User(
          id: _user['id'],
          firstName: _user['firstName'],
          lastName: _user['lastName'],
          defaultCurrency: _user['defaultCurrency'],
          email: _user['email'],
          pictureUrl: _user['pictureUrl'],
          registrationStatus: _user['registrationStatus'],
          phoneNumber: _user['phoneNumber'],
        ),
      );
    }
    final Group _group = Group(
      id: _data['id'],
      name: _data['name'],
      pictureUrl: _data['pictureUrl'],
      updatedAt: _data['updatedAt'],
      members: _membersList,
    );
    return _group;
  }

  /// Get all groups of current user
  static Future<List<Group>> getGroups(
      [DocumentReference documentReference]) async {
    List<DocumentSnapshot> _docList;
    if (documentReference == null) {
      final _queryList = await _firestore
          .collection('users')
          .document(globalUser.id)
          .collection('groups')
          .getDocuments();
      _docList = _queryList.documents;
    } else {
      final _querylist =
          await documentReference.collection('groups').getDocuments();
      _docList = _querylist.documents;
    }

    List<Group> _groups = [];
    for (var _group in _docList) {
      /// This parses the members list from database as list of [User] objects
      List<User> _membersList = [];
      for (var _data in _group.data['members']) {
        _membersList.add(
          User(
            id: _data['id'],
            firstName: _data['firstName'],
            lastName: _data['lastName'],
            defaultCurrency: _data['defaultCurrency'],
            email: _data['email'],
            pictureUrl: _data['pictureUrl'],
            registrationStatus: _data['registrationStatus'],
            phoneNumber: _data['phoneNumber'],
          ),
        );
      }

      final _data = _group.data;
      final Group _grp = Group(
        id: _data['id'],
        name: _data['name'],
        pictureUrl: _data['pictureUrl'],
        updatedAt: _data['updatedAt'],
        members: _membersList,
      );
      _groups.add(_grp);
    }
    return _groups;
  }

  /// Creates a group
  static Future<void> createGroup({Group group}) async {
    final _docId = _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('groups')
        .document()
        .documentID;
    List<Map<String, String>> _membersList = [];
    for (var _user in group.members) {
      _membersList.add({
        'id': _user.id,
        'firstName': _user.firstName,
        'lastName': _user.lastName,
        'defaultCurrency': _user.defaultCurrency,
        'email': _user.email,
        'pictureUrl': _user.pictureUrl,
        'registrationStatus': '${_user.registrationStatus}',
        'phoneNumber': _user.phoneNumber,
      });
    }
    for (var _user in group.members) {
      await _firestore
          .collection('users')
          .document(_user.id)
          .collection('groups')
          .document(_docId)
          .setData(
        {
          'id': _docId,
          'name': group.name,
          'pictureUrl': group.pictureUrl,
          'updatedAt': DateTime.now().toIso8601String(),
          'members': _membersList,
        },
        merge: true,
      );
    }
  }

  /// Updates the [Group] with [id] as [groupId], with the provided [Group].
  /// [name] and [members] property must be provided otherwise they will be
  /// overwritten by [null] values
  static Future<void> updateGroup({String groupId, Group group}) async {
    List<Map<String, String>> _membersList = [];
    for (var _user in group.members) {
      _membersList.add(
        {
          'id': _user.id,
          'firstName': _user.firstName,
          'lastName': _user.lastName,
          'defaultCurrency': _user.defaultCurrency,
          'email': _user.email,
          'pictureUrl': _user.pictureUrl,
          'registrationStatus': '${_user.registrationStatus}',
          'phoneNumber': _user.phoneNumber,
        },
      );
    }
    for (var _user in group.members) {
      await _firestore
          .collection('users')
          .document(_user.id)
          .collection('groups')
          .document(group.id)
          .setData(
        {
          /// [id] and [pictureUrl] cannot be updated so ommited here
          'name': group.name,
          'updatedAt': Timestamp.now().toString(),
          'members': _membersList,
        },
        merge: true,
      );
    }
  }

  /// Adds the provided [User] to the [Group] with the given [groupId].
  /// This function does not updates the group-expenses after adding the user
  static Future<void> addUserToGroup({String groupId, User newUser}) async {
    final _group = await getGroupById(id: groupId);
    _group.members.add(newUser);
    await updateGroup(groupId: groupId, group: _group);
  }

  /// Removes the [User] with given [userId] from the [Group] with
  /// given [groupId].
  /// This function does not update the group-expenses after removing the user
  static Future<void> removeUserFromGroup(
      {String groupId, String userId}) async {
    final _group = await getGroupById(id: groupId);
    _group.members.removeWhere((user) {
      return user.id == userId;
    });
    await updateGroup(group: _group, groupId: groupId);
  }

  /// Deletes a group along with its expenses for all the members of the group
  static Future<void> deleteGroup({String id}) async {
    final _group = await getGroupById(id: id);
    for (var _user in _group.members) {
      final _d = await _firestore
          .collection('users')
          .document(_user.id)
          .collection('groups')
          .getDocuments();

      final _e = _d.documents.firstWhere(
        (element) => element.documentID == id,
        orElse: () => null,
      );

      await _e.reference.delete();

      final _query = _firestore
          .collection('users')
          .document(_user.id)
          .collection('expenses')
          .where('groupId', isEqualTo: id);

      await _query.getDocuments().then(
            (_docList) => _docList.documents.forEach(
              (document) async {
                await document.reference.delete();
              },
            ),
          );
    }
  }
}

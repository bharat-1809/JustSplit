import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/api/functions/expenses_functions.dart';
import 'package:contri_app/api/models/expense_model.dart';
import 'package:contri_app/api/models/friend_model.dart';
import 'package:contri_app/api/models/user_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:flutter/material.dart';

class FriendFunctions {
  static final _firestore = Firestore.instance;

  /// Get a friend of current user by its id
  static Future<Friend> getFriendById({String id}) async {
    final _queryList = await _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('friends')
        .where('id', isEqualTo: id)
        .getDocuments();
    final _docList = _queryList.documents;
    final _data = _docList[0].data;
    final Friend _friend = Friend(
      id: _data['id'],
      friend: User(
        id: _data['friend']['id'],
        firstName: _data['friend']['firstName'],
        lastName: _data['friend']['lastName'],
        defaultCurrency: _data['friend']['defaultCurrency'],
        email: _data['friend']['email'],
        phoneNumber: _data['friend']['phoneNumber'],
        pictureUrl: _data['friend']['pictureUrl'],
        registrationStatus: _data['friend']['registrationStatus'],
      ),
      balance: _data['balance'],
    );
    return _friend;
  }

  /// Get a list of friends of the current user
  static Future<List<Friend>> getFriends([DocumentReference documentReference]) async {
    List<DocumentSnapshot> _docList;
    if (documentReference == null) {
      final _queryList = await _firestore
          .collection('users')
          .document(globalUser.id)
          .collection('friends')
          .getDocuments();
      _docList = _queryList.documents;
    } else {
      final _queryList = await documentReference.collection('friends').getDocuments();
      _docList = _queryList.documents;
    }
    List<Friend> _friends = [];
    for (var _friend in _docList) {
      final _data = _friend.data;
      final Friend _fr = Friend(
        id: _data['id'],
        friend: User(
          id: _data['friend']['id'],
          firstName: _data['friend']['firstName'],
          lastName: _data['friend']['lastName'],
          defaultCurrency: _data['friend']['defaultCurrency'],
          email: _data['friend']['email'],
          phoneNumber: _data['friend']['phoneNumber'],
          pictureUrl: _data['friend']['pictureUrl'],
          registrationStatus: _data['friend']['registrationStatus'],
        ),
        balance: _data['balance'],
      );
      _friends.add(_fr);
    }
    return _friends;
  }

  /// Create a new friend
  static Future<String> createFriend({Friend friend}) async {
    final _queryList = await _firestore.collection('users').getDocuments();
    final _docList = _queryList.documents;
    final _userDoc = _docList.firstWhere(
      (element) => element.data['phoneNumber'] == friend.friend.phoneNumber,
      orElse: () => null,
    );
    if (_userDoc != null) {
      final _doc = _userDoc;
      final _data = _doc.data;
      await _firestore
          .collection('users')
          .document(globalUser.id)
          .collection('friends')
          .document(_userDoc.data['id'])
          .setData(
        {
          'id': _data['id'],
          'friend': {
            'id': _data['id'],
            'firstName': _data['firstName'],
            'lastName': _data['lastName'],
            'defaultCurrency': _data['defaultCurrency'],
            'email': _data['email'],
            'pictureUrl': _data['pictureUrl'],
            'registrationStatus': _data['registrationStatus'],
            'phoneNumber': _data['phoneNumber'],
          },
        },
        merge: true,
      );
      await _firestore
          .collection('users')
          .document(_userDoc.data['id'])
          .collection('friends')
          .document(globalUser.id)
          .setData(
        {
          'id': globalUser.id,
          'friend': {
            'id': globalUser.id,
            'firstName': globalUser.firstName,
            'lastName': globalUser.lastName,
            'defaultCurrency': globalUser.defaultCurrency,
            'email': globalUser.email,
            'pictureUrl': globalUser.pictureUrl,
            'registrationStatus': globalUser.registrationStatus,
            'phoneNumber': globalUser.phoneNumber,
          },
        },
        merge: true,
      );

      return _userDoc.data['id'];
    } else {
      final _docId = _firestore.collection('users').document().documentID;
      await _firestore.collection('users').document(_docId).setData(
        {
          'id': _docId,
          'firstName': friend.friend.firstName,
          'lastName': friend.friend.lastName,
          'defaultCurrency': friend.friend.defaultCurrency ?? 'INR',
          'registrationStatus': '${registrationStatus.invited}',
          'pictureUrl': friend.friend.pictureUrl,

          /// Phone NUmber is very important in case of invited friend
          /// creation as it links this doc when the invited user registers as new user
          'phoneNumber': friend.friend.phoneNumber,
        },
        merge: true,
      );
      await _firestore
          .collection('users')
          .document(globalUser.id)
          .collection('friends')
          .document(_docId)
          .setData(
        {
          'id': _docId,
          'friend': {
            'id': _docId,
            'firstName': friend.friend.firstName,
            'lastName': friend.friend.lastName,
            'defaultCurrency': friend.friend.defaultCurrency,
            'registrationStatus': '${registrationStatus.invited}',
            'pictureUrl': friend.friend.pictureUrl,
            'phoneNumber': friend.friend.phoneNumber,
          },
        },
        merge: true,
      );
      await _firestore
          .collection('users')
          .document(_docId)
          .collection('friends')
          .document(globalUser.id)
          .setData(
        {
          'id': globalUser.id,
          'friend': {
            'id': globalUser.id,
            'firstName': globalUser.firstName,
            'lastName': globalUser.lastName,
            'defaultCurrency': globalUser.defaultCurrency,
            'email': globalUser.email,
            'pictureUrl': globalUser.pictureUrl,
            'registrationStatus': globalUser.registrationStatus,
            'phoneNumber': globalUser.phoneNumber,
          },
        },
        merge: true,
      );

      return _docId;
    }
  }

  /// Checks if the Friend can be deleted or not
  /// If the friend shares a group with the user then they cannot be deleted
  static bool canDeleteFriend({@required String id}) {
    for (var _grp in getCurrentGroups) {
      final _frnd = _grp.members.firstWhere(
        (usr) => usr.id == id,
        orElse: () => null,
      );

      if (_frnd != null) {
        return false;
      }
    }

    return true;
  }

  /// Delete a friend. This deletes all the non-group expenses with that friend also
  /// For group expenses the user needs to delete them manually
  static Future<void> deleteFriend({@required String id}) async {
    final _listExp = getCurrentExpenses;

    final List<Expense> _friendExpenses = [];

    _listExp.forEach((exp) async {
      if (exp.to == id) {
        // Not awaiting for the function to execute as we are removing from the local list
        // so the it will be updated locally and requests will be made to the database
        // This way there's no need of again requesting the updated values from the database
        ExpensesFunctions.deleteExpense(id: exp.id);
        _friendExpenses.add(exp);
      }
    });

    // Delete the expenses from the local list
    getCurrentExpenses.removeWhere((exp) => _friendExpenses.contains(exp));

    // Delete the friend from the local list
    getCurrentFriends.removeWhere((f) => (f.id == id));

    // Delete the friend from the database
    _firestore
        .collection('users')
        .document(globalUser.id)
        .collection('friends')
        .document(id)
        .delete();

    // Delete the current user from deleted user's friend list
    _firestore
        .collection('users')
        .document(id)
        .collection('friends')
        .document(globalUser.id)
        .delete();
  }
}

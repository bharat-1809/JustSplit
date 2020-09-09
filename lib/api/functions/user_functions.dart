import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/api/models/user_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFunctions {
  static final _firestore = Firestore.instance;

  /// Get the specific user document
  static Future<DocumentSnapshot> getUserDocument({String id}) async {
    final _querySnapshots = await _firestore
        .collection('users')
        .where('id', isEqualTo: id)
        .getDocuments();
    final _doc = _querySnapshots.documents[0];
    return _doc;
  }

  static Future<User> getCurrentUser() async {
    // First getting the email of the current user for finding the doc in database
    final _firebaseUser = await FirebaseAuth.instance.currentUser();
    final _email = _firebaseUser.email;
    final _queryList = await _firestore
        .collection('users')
        .where('email', isEqualTo: _email)
        .getDocuments();
    final _doc = _queryList.documents[0];
    final _data = _doc.data;

    final User _user = User(
      id: _data['id'],
      firstName: _data['firstName'],
      lastName: _data['lastName'],
      defaultCurrency: _data['defaultCurrency'],
      email: _data['email'],
      pictureUrl: _data['pictureUrl'],
      registrationStatus: _data['registrationStatus'],
      phoneNumber: _data['phoneNumber'],
    );
    return _user;
  }

  /// Update the current user's details
  static Future<void> updateUserDetails(User user) async {
    final _docId = globalUser.id;
    await _firestore.collection('users').document(_docId).setData(
      {
        /// [id], [email] and [registrationStatus] cannot be updated
        'firstName': user.firstName,
        'lastName': user.lastName,
        'defaultCurrency': user.defaultCurrency,
        'pictureUrl': user.pictureUrl,
        'phoneNumber': user.phoneNumber,
      },
      merge: true,
    );

    for (var _friend in getCurrentFriends) {
      await _firestore
          .collection('users')
          .document(_friend.id)
          .collection('friends')
          .document(globalUser.id)
          .setData(
        {
          "friend": {
            /// [id], [email] and [registrationStatus] cannot be updated
            'firstName': user.firstName,
            'lastName': user.lastName,
            'defaultCurrency': user.defaultCurrency,
            'pictureUrl': user.pictureUrl,
            'phoneNumber': user.phoneNumber,
            'email': globalUser.email,
            'id': globalUser.id,
            'registrationStatus': globalUser.registrationStatus,
          }
        },
        merge: true,
      );
    }
  }

  /// Get User by id
  static Future<User> getUserById({String id}) async {
    final _docList = await _firestore
        .collection('users')
        .where('id', isEqualTo: id)
        .getDocuments();
    final _doc = _docList.documents[0];
    final _data = _doc.data;
    final User _user = User(
      id: _data['id'],
      firstName: _data['firstName'],
      lastName: _data['lastName'],
      defaultCurrency: _data['defaultCurrency'],
      email: _data['email'],
      pictureUrl: _data['pictureUrl'],
      registrationStatus: _data['registrationStatus'],
      phoneNumber: _data['phoneNumber'],
    );
    return _user;
  }

  /// Creates a user [to be used only once while registering]
  static Future<void> createUser(User user) async {
    /// This checks whether a document is already created or not
    /// In case of an unregistered [Friend], created earlier, who now tries to register
    /// this function will ensure that the data is merged into existing document
    final _queryList = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: user.phoneNumber)
        .getDocuments();
    print('${_queryList.documents.toString()}');
    final _docList = _queryList.documents;

    if (_docList.length == 0) {
      final _docId = _firestore.collection('users').document().documentID;
      await _firestore.collection('users').document(_docId).setData(
        {
          'id': _docId,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'defaultCurrency': user.defaultCurrency,
          'email': user.email,
          'pictureUrl': user.pictureUrl,
          'registrationStatus': '${registrationStatus.registered}',
          'phoneNumber': user.phoneNumber,
        },
        merge: false,
      );
    } else {
      final _docId = _docList[0].documentID;
      await _firestore.collection('users').document(_docId).setData(
        {
          'id': _docId,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'defaultCurrency': user.defaultCurrency,
          'email': user.email,
          'pictureUrl': user.pictureUrl,
          'registrationStatus': '${registrationStatus.registered}',
          'phoneNumber': user.phoneNumber,
        },
        merge: true,
      );

      final _fqueryList = await _firestore
          .collection('users')
          .document(_docId)
          .collection('friends')
          .getDocuments();
      final _fdocList = _fqueryList.documents;

      for (var _fDoc in _fdocList) {
        await _firestore
            .collection('users')
            .document(_fDoc.data['id'])
            .collection('friends')
            .document(_docId)
            .setData(
          {
            'friend': {
              'firstName': user.firstName,
              'lastName': user.lastName,
              'defaultCurrency': user.defaultCurrency,
              'pictureUrl': user.pictureUrl,
              'phoneNumber': user.phoneNumber,
              'email': user.email,
              'id': _docId,
              'registrationStatus': '${registrationStatus.registered}',
            }
          },
          merge: true,
        );
      }
    }
  }
}

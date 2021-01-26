import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contri_app/sdk/models/expense_model/expense_model.dart';
import 'package:contri_app/global/global_helpers.dart';

class ExpensesFunctions {
  static final _firestore = Firestore.instance;

  /// Get expense for the given [id] for the given [userId]
  static Future<Expense> getExpenseById(
      {String expenseId, String userId}) async {
    final _docListQuerySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('expenses')
        .where('id', isEqualTo: expenseId)
        .getDocuments();
    final _docList = _docListQuerySnapshot.documents;
    final _data = _docList[0].data;

    final Expense _exp = Expense.fromJson(_data);
    return _exp;
  }

  /// Returns current [User]'s expenses as a list of [Expense]
  static Future<List<Expense>> getExpenses(
      [DocumentReference documentReference]) async {
    List<DocumentSnapshot> _docList;

    if (documentReference == null) {
      final _docID = globalUser.id;
      final _docListQuerySnapshot = await _firestore
          .collection('users')
          .document(_docID)
          .collection('expenses')
          .getDocuments();
      _docList = _docListQuerySnapshot.documents;
    } else {
      final _docListQuerySnapshot =
          await documentReference.collection('expenses').getDocuments();
      _docList = _docListQuerySnapshot.documents;
    }

    List<Expense> _expenses = [];

    for (var _doc in _docList) {
      final _data = _doc.data;
      final _exp = Expense.fromJson(_data);
      _expenses.add(_exp);
    }

    return _expenses;
  }

  /// Get the [Expense] with the gicen [id] from the local expenses list
  static List<Expense> getAllExpensesByUserId(
      {String userId, List<Expense> expenses}) {
    List<Expense> _expenses = [];
    for (var expense in expenses) {
      if (expense.to == userId) {
        _expenses.add(expense);
      }
    }
    return _expenses;
  }

  /// Create [Expense] for the current user.
  /// In case of group expenses the [expenseUser] property shouldn't
  /// be null and length > 0
  static Future<void> createExpense(Expense expense) async {
    final _docId = globalUser.id;

    /// This  creates a new document for the expense
    final _expenseDocId = _firestore
        .collection('users')
        .document(_docId)
        .collection('expenses')
        .document()
        .documentID;

    // Set the expense id
    expense.id = _expenseDocId;

    /// Saves the expense in current users's database
    await _firestore
        .collection('users')
        .document(_docId)
        .collection('expenses')
        .document(_expenseDocId)
        .setData(
          expense.toJson(),
          merge: true,
        );

    /// In case of a group expense, it iterates through the [ExpenseUsers] list
    /// and add the expense in every user's database
    if (expense.expenseUsers != null) {
      for (var _user in expense.expenseUsers) {
        final Expense _tmpExp = Expense(
          id: _expenseDocId,
          groupId: expense.groupId,
          pictureUrl: expense.pictureUrl,
          date: expense.date,
          description: expense.description,
          from: _user.user.id,
          to: _docId,
          createdBy: expense.createdBy,
          cost: expense.cost,
          comments: expense.comments,
          expenseUsers: expense.expenseUsers,
          splitType: expense.splitType,
        );

        await _firestore
            .collection('users')
            .document(_user.userId)
            .collection('expenses')
            .document(_expenseDocId)
            .setData(
              _tmpExp.toJson(),
              merge: true,
            );
      }

      /// If the [ExpenseUsers] list is null i.e non-group expense then the
      /// expense is added to the [to] user
    } else {
      final Expense _tmpExp = Expense(
        id: _expenseDocId,
        groupId: expense.groupId,
        pictureUrl: expense.pictureUrl,
        date: expense.date,
        description: expense.description,
        from: expense.to,
        to: expense.from,
        createdBy: expense.createdBy,
        cost: expense.cost,
        owedShare: -expense.owedShare,
        comments: expense.comments,
        splitType: expense.splitType,
      );

      await _firestore
          .collection('users')
          .document(expense.to)
          .collection('expenses')
          .document(_expenseDocId)
          .setData(
            _tmpExp.toJson(),
            merge: true,
          );
    }
  }

  /// Updates the existing [Expense] for all the users of the expense.
  /// This function requires [from], [to], [cost], [description], [createdBy] and [comments]
  /// property of [Expense] to have data (updated data or copied from the
  /// previous version of this [Expense] ) otherwise the data will be overridden
  /// by [null] values
  static Future<void> updateExpense({String id, Expense expense}) async {
    final _docId = globalUser.id;

    /// Copy of the original expense
    final _origExp = getCurrentExpenses.firstWhere(
      (exp) => exp.id == id,
      orElse: () => null,
    );

    /// Cannot update the [id], [groupId], [groupId], [pictureUrl], [from] and [to]  so, emitted here
    final _expCpy = Expense(
      id: _origExp.id,
      groupId: _origExp.groupId,
      pictureUrl: _origExp.pictureUrl,
      description: expense.description,
      cost: expense.cost,
      owedShare: expense.owedShare,
      comments: expense.comments,
      splitType: expense.splitType,
      date: expense.date,
      updatedBy: expense.updatedBy,
      createdBy: _origExp.createdBy,
      // FIXME: Update this with new expense users list when the group_settings is added
      expenseUsers: _origExp.expenseUsers,
      from: _origExp.from,
      to: _origExp.to,
    );

    await _firestore
        .collection('users')
        .document(_docId)
        .collection('expenses')
        .document(id)
        .setData(
          _expCpy.toJson(),
          merge: true,
        );

    /// If the [ExpenseUsers] list is not [null] i.e a group expense then it
    /// iterates through this list and updates the expense for every user
    if (expense.expenseUsers != null) {
      for (var _user in expense.expenseUsers) {
        final _tmpExp = Expense(
          id: _origExp.id,
          groupId: _origExp.groupId,
          pictureUrl: _origExp.pictureUrl,
          createdBy: _origExp.createdBy,
          from: _user.user.id,
          to: _docId,
          cost: expense.cost,
          comments: expense.comments,
          date: expense.date,
          description: expense.description,
          // FIXME: Update this with new expense users list when the group_settings is added
          expenseUsers: expense.expenseUsers,
          splitType: expense.splitType,
          updatedBy: expense.updatedBy,
        );

        await _firestore
            .collection('users')
            .document(_user.userId)
            .collection('expenses')
            .document(id)
            .setData(
              _tmpExp.toJson(),
              merge: true,
            );
      }

      /// If the [ExpenseUsers] list is [null] then it updates the expense for [to] user
    } else {
      final _tmpExp = Expense(
        id: _origExp.id,
        groupId: _origExp.groupId,
        pictureUrl: _origExp.pictureUrl,
        createdBy: _origExp.createdBy,
        from: _origExp.to,
        to: _origExp.from,
        cost: expense.cost,
        comments: expense.comments,
        date: expense.date,
        description: expense.description,
        owedShare: -expense.owedShare,
        splitType: expense.splitType,
        updatedBy: expense.updatedBy,
      );

      await _firestore
          .collection('users')
          .document(expense.to)
          .collection('expenses')
          .document(id)
          .setData(
            _tmpExp.toJson(),
            merge: true,
          );
    }
  }

  /// Deletes the [Expense] from all [Users]' database
  static Future<void> deleteExpense({String id}) async {
    final Expense _expense = await getExpenseById(
      expenseId: id,
      userId: globalUser.id,
    );

    /// Deletes the expense for group-users
    if (_expense.expenseUsers != null) {
      /// Before deleting expense update the [deletedBy] field for notifications
      for (var _user in _expense.expenseUsers) {
        await _firestore
            .collection('users')
            .document(_user.userId)
            .collection('expenses')
            .document(id)
            .setData(
          {
            'deletedBy': globalUser.id,
          },
          merge: true,
        );
      }

      for (var _user in _expense.expenseUsers) {
        await _firestore
            .collection('users')
            .document(_user.userId)
            .collection('expenses')
            .document(id)
            .delete();
      }

      /// In case of non-group expense it deletes the expense for [to] user
    } else {
      /// Before deleting expense update the [deletedBy] field for notifications
      await _firestore
          .collection('users')
          .document(globalUser.id)
          .collection('expenses')
          .document(id)
          .setData(
        {
          'deletedBy': globalUser.id,
        },
        merge: true,
      );

      /// Deletes the expense for current user
      await _firestore
          .collection('users')
          .document(globalUser.id)
          .collection('expenses')
          .document(id)
          .delete();

      /// Before deleting expense update the [deletedBy] field for notifications
      await _firestore
          .collection('users')
          .document(_expense.to)
          .collection('expenses')
          .document(id)
          .setData(
        {
          'deletedBy': globalUser.id,
        },
        merge: true,
      );

      await _firestore
          .collection('users')
          .document(_expense.to)
          .collection('expenses')
          .document(id)
          .delete();
    }
  }
}

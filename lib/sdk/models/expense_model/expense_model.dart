import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

@JsonSerializable(explicitToJson: true)

/// Expense model
class Expense {
  Expense({
    this.id,
    this.groupId,
    this.pictureUrl,
    this.date,
    this.description,
    this.from,
    this.to,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.owedShare,
    this.cost,
    this.comments,
    this.expenseUsers,
    this.splitType,
  });

  /// Id of the document containg the expense
  String id;
  String pictureUrl;

  /// Group id incase of a group-expense
  String groupId;
  String description;
  double cost; // Can be positive or negative depending on the expense type

  /// For non-group expense only
  double owedShare;

  /// From and to will be used if there is a non-group expense
  /// if there is a group expense then the total amount will be saved in cost with +ve sign
  /// and All the users bearing that cost will be in [ExpenseUsers] list
  /// This list will remain empty if there is a non-group expense
  String from; // user_id of the user from which payment is initiated
  String to;
  String createdBy;

  /// For update notifications
  String updatedBy;

  /// For deleted expense notifications
  /// DO NOT USE IN FRONTEND except in firebase-functions
  String deletedBy;
  String date;

  /// This split type is with respect to the creator of expense
  String splitType;
  /*
    String receipt, // TODO: Implement receipt uploading 
    Category category // TODO: Implement the category model for cool prefix icons for expenses
    */
  /// This list is for only group expenses. In case of non-group expenses this remains empty or [null]
  List<ExpenseUsers> expenseUsers; // Incase of group expenses
  List comments;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ExpenseUsers {
  ExpenseUsers({
    this.user,
    this.userId,
    this.paidShare,
    this.owedShare,
    this.netBalance,
  });
  User user;
  String userId;
  double paidShare;
  double owedShare;
  double netBalance;

  factory ExpenseUsers.fromJson(Map<String, dynamic> json) =>
      _$ExpenseUsersFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseUsersToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Balance {
  Balance({
    this.from,
    this.to,
    this.balance,
    this.timestamp,
  });
  String from;
  String to;
  double balance;
  DateTime timestamp;

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceToJson(this);
}

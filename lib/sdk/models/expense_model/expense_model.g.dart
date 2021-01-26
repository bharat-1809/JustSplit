// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return Expense(
    id: json['id'] as String,
    groupId: json['groupId'] as String,
    pictureUrl: json['pictureUrl'] as String,
    date: json['date'] as String,
    description: json['description'] as String,
    from: json['from'] as String,
    to: json['to'] as String,
    createdBy: json['createdBy'] as String,
    updatedBy: json['updatedBy'] as String,
    deletedBy: json['deletedBy'] as String,
    owedShare: (json['owedShare'] as num)?.toDouble(),
    cost: (json['cost'] as num)?.toDouble(),
    comments: json['comments'] as List,
    expenseUsers: (json['expenseUsers'] as List)
        ?.map((e) =>
            e == null ? null : ExpenseUsers.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    splitType: json['splitType'] as String,
  );
}

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'pictureUrl': instance.pictureUrl,
      'groupId': instance.groupId,
      'description': instance.description,
      'cost': instance.cost,
      'owedShare': instance.owedShare,
      'from': instance.from,
      'to': instance.to,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'deletedBy': instance.deletedBy,
      'date': instance.date,
      'splitType': instance.splitType,
      'expenseUsers': instance.expenseUsers?.map((e) => e?.toJson())?.toList(),
      'comments': instance.comments,
    };

ExpenseUsers _$ExpenseUsersFromJson(Map<String, dynamic> json) {
  return ExpenseUsers(
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    userId: json['userId'] as String,
    paidShare: (json['paidShare'] as num)?.toDouble(),
    owedShare: (json['owedShare'] as num)?.toDouble(),
    netBalance: (json['netBalance'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ExpenseUsersToJson(ExpenseUsers instance) =>
    <String, dynamic>{
      'user': instance.user?.toJson(),
      'userId': instance.userId,
      'paidShare': instance.paidShare,
      'owedShare': instance.owedShare,
      'netBalance': instance.netBalance,
    };

Balance _$BalanceFromJson(Map<String, dynamic> json) {
  return Balance(
    from: json['from'] as String,
    to: json['to'] as String,
    balance: (json['balance'] as num)?.toDouble(),
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
  );
}

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'balance': instance.balance,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

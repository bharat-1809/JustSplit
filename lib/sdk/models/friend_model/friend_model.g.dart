// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend(
    id: json['id'] as String,
    friend: json['friend'] == null
        ? null
        : User.fromJson(json['friend'] as Map<String, dynamic>),
    balance: (json['balance'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'friend': instance.friend?.toJson(),
      'balance': instance.balance,
    };

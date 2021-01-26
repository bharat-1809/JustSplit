import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Friend {
  Friend({
    this.id,
    this.friend,
    this.balance,
  });
  String id;
  User friend;
  // Whats the balance on you. Eg if balance = 50 then you have to pay else if balance = -50 it means that you are owed 50
  double balance;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  Map<String, dynamic> toJson() => _$FriendToJson(this);
}

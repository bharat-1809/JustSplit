import 'package:contri_app/api/models/user_model.dart';

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
}

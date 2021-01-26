import 'package:contri_app/sdk/models/expense_model/expense_model.dart';
import 'package:contri_app/sdk/models/friend_model/friend_model.dart';
import 'package:contri_app/sdk/models/group_model/group_model.dart';

class ScreenArguments {
  /// This can be userId or groupId
  final Friend friend;
  final Group group;
  final Expense expense;
  final int homeIndex;

  ScreenArguments({this.homeIndex, this.friend, this.group, this.expense});
}

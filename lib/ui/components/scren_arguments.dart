import 'package:contri_app/api/models/expense_model.dart';
import 'package:contri_app/api/models/friend_model.dart';
import 'package:contri_app/api/models/group_model.dart';

class ScreenArguments {
  /// This can be userId or groupId
  final Friend friend;
  final Group group;
  final Expense expense;
  final int homeIndex;

  ScreenArguments({this.homeIndex, this.friend, this.group, this.expense});
}

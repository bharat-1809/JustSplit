import 'package:contri_app/api/models/user_model.dart';

class Group {
  Group({
    this.id,
    this.name,
    this.pictureUrl,
    this.updatedAt,
    this.members,
  });
  String id;
  String name;
  String pictureUrl;

  /// This should be changed only while updating the group
  String updatedAt;
  List<User> members;
}

import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

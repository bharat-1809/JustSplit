import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()

/// Comment model for adding private comments
class Comment {
  Comment({this.id, this.comment, this.dateTime});

  /// Unique id of comment
  String id;

  /// Body of the comment. Cannot be null
  String comment;

  /// DateTime is necessary for sorting the comments as per their timestamp
  DateTime dateTime;

  /// Converts a JSON map to a [Comment] object
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  /// Converts a [Comment] object to a JSON map
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

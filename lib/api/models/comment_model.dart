/// Comment model for adding private comments
class Comment {
  Comment({this.id, this.comment, this.dateTime});

  /// Unique id of comment
  String id;

  /// Body of the comment. Cannot be null
  String comment;

  /// DateTime is necessary for sorting the comments as per their timestamp
  DateTime dateTime;

  /// Converts a [Comment] object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  /// Converts a JSON map to a [Comment] object
  Comment.fromJson(Map<String, dynamic> json)
      : comment = json['comment'],
        id = json['id'],
        dateTime = DateTime.parse(json['dateTime']);
}

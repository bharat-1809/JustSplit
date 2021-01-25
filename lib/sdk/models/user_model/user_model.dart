import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.pictureUrl,
    this.email,
    this.defaultCurrency,
    this.registrationStatus,
    this.phoneNumber,
  });

  String id;
  String firstName;
  String lastName;
  String pictureUrl;
  String email;
  String defaultCurrency;
  String registrationStatus;
  String phoneNumber;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum registrationStatus {
  registered,
  invited,
  dummy,
}

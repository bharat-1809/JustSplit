// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    pictureUrl: json['pictureUrl'] as String,
    email: json['email'] as String,
    defaultCurrency: json['defaultCurrency'] as String,
    registrationStatus: json['registrationStatus'] as String,
    phoneNumber: json['phoneNumber'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'pictureUrl': instance.pictureUrl,
      'email': instance.email,
      'defaultCurrency': instance.defaultCurrency,
      'registrationStatus': instance.registrationStatus,
      'phoneNumber': instance.phoneNumber,
    };

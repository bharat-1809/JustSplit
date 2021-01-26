// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    id: json['id'] as String,
    name: json['name'] as String,
    pictureUrl: json['pictureUrl'] as String,
    updatedAt: json['updatedAt'] as String,
    members: (json['members'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pictureUrl': instance.pictureUrl,
      'updatedAt': instance.updatedAt,
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
    };

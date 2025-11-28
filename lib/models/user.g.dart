// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'role': _$UserRoleEnumMap[instance.role]!,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.merchant: 'merchant',
  UserRole.client: 'client',
};

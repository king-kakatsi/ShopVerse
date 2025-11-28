// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
  id: json['id'] as String,
  merchantId: json['merchantId'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String,
  isOpen: json['isOpen'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
  'id': instance.id,
  'merchantId': instance.merchantId,
  'name': instance.name,
  'description': instance.description,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'imageUrl': instance.imageUrl,
  'isOpen': instance.isOpen,
  'createdAt': instance.createdAt.toIso8601String(),
};

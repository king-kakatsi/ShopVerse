// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
  id: json['id'] as String,
  name: json['name'] as String,
  symbol: json['symbol'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'symbol': instance.symbol,
  'price': instance.price,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
};

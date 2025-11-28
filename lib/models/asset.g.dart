// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
  id: json['id'] as String,
  name: json['name'] as String,
  symbol: json['symbol'] as String,
  basePrice: (json['basePrice'] as num).toDouble(),
  btcPriceSnapshot: (json['btcPriceSnapshot'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String,
  description: json['description'] as String,
  quantity: (json['quantity'] as num).toInt(),
  network: json['network'] as String,
  paymentMethod: json['paymentMethod'] as String,
  vendor: json['vendor'] as String,
  storeId: json['storeId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'symbol': instance.symbol,
  'basePrice': instance.basePrice,
  'btcPriceSnapshot': instance.btcPriceSnapshot,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
  'quantity': instance.quantity,
  'network': instance.network,
  'paymentMethod': instance.paymentMethod,
  'vendor': instance.vendor,
  'storeId': instance.storeId,
  'createdAt': instance.createdAt.toIso8601String(),
};

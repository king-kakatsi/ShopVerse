import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final String imageUrl;
  final String description;
  final int quantity;
  final String network;
  final String paymentMethod;
  final String vendor;
  final DateTime createdAt;

  Asset({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.quantity,
    required this.network,
    required this.paymentMethod,
    required this.vendor,
    required this.createdAt,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);
}

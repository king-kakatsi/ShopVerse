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

  Asset({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);
}

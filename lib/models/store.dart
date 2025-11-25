import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

/// Store model for merchant shops
@JsonSerializable()
class Store {
  final String id;
  final String merchantId;
  final String name;
  final String description;
  final double latitude; // GPS coordinates
  final double longitude;
  final String imageUrl;
  final bool isOpen; // Store status (open/closed)
  final DateTime createdAt;

  Store({
    required this.id,
    required this.merchantId,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    this.isOpen = true,
    required this.createdAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);

  /// Create a copy with updated fields
  Store copyWith({
    String? id,
    String? merchantId,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    String? imageUrl,
    bool? isOpen,
    DateTime? createdAt,
  }) {
    return Store(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      isOpen: isOpen ?? this.isOpen,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

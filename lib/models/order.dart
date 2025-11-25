import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

/// Order status
enum OrderStatus { pending, confirmed, completed, cancelled }

/// Order item (product with quantity)
@JsonSerializable()
class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double pricePerUnit; // Price at time of order

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
  });

  double get total => quantity * pricePerUnit;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

/// Order model
@JsonSerializable()
class Order {
  final String id;
  final String clientId;
  final String storeId;
  final List<OrderItem> items;
  final double totalPrice;
  final double btcPriceSnapshot; // BTC price at time of order
  final OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.clientId,
    required this.storeId,
    required this.items,
    required this.totalPrice,
    required this.btcPriceSnapshot,
    this.status = OrderStatus.pending,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  /// Create a copy with updated fields
  Order copyWith({
    String? id,
    String? clientId,
    String? storeId,
    List<OrderItem>? items,
    double? totalPrice,
    double? btcPriceSnapshot,
    OrderStatus? status,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      storeId: storeId ?? this.storeId,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      btcPriceSnapshot: btcPriceSnapshot ?? this.btcPriceSnapshot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

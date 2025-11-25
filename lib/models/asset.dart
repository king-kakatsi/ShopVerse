import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset {
  final String id;
  final String name;
  final String symbol;
  final double basePrice; // Base price in FCFA (doesn't change)
  final double
  btcPriceSnapshot; // BTC price when product was created/last updated
  final String imageUrl;
  final String description;
  final int quantity;
  final String network;
  final String paymentMethod;
  final String vendor;
  final String? storeId; // Optional for now to support legacy data
  final DateTime createdAt;

  Asset({
    required this.id,
    required this.name,
    required this.symbol,
    required this.basePrice,
    required this.btcPriceSnapshot,
    required this.imageUrl,
    required this.description,
    required this.quantity,
    required this.network,
    required this.paymentMethod,
    required this.vendor,
    this.storeId,
    required this.createdAt,
  });

  /// Calculate current price based on BTC fluctuation
  /// Formula: currentPrice = basePrice * (currentBTC / snapshotBTC)
  double getCurrentPrice(double currentBtcPrice) {
    if (btcPriceSnapshot == 0) return basePrice;
    return basePrice * (currentBtcPrice / btcPriceSnapshot);
  }

  /// Get price change percentage
  double getPriceChangePercentage(double currentBtcPrice) {
    final currentPrice = getCurrentPrice(currentBtcPrice);
    return ((currentPrice - basePrice) / basePrice) * 100;
  }

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);
}

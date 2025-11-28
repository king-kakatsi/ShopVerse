import 'package:shop_verse/models/asset.dart';

class CartItem {
  final Asset product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalBasePrice => product.basePrice * quantity;

  double getTotalPrice(double currentBtcPrice) {
    return product.getCurrentPrice(currentBtcPrice) * quantity;
  }
}

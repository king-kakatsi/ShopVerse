import 'package:flutter/material.dart';
import 'package:shop_verse/models/asset.dart';
import 'package:shop_verse/models/cart_item.dart';
import 'package:shop_verse/models/order.dart';
import 'package:uuid/uuid.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.from(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => _items.isEmpty;

  void addToCart(Asset product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(Asset product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double getTotalPrice(double currentBtcPrice) {
    return _items.fold(
      0.0,
      (sum, item) => sum + item.getTotalPrice(currentBtcPrice),
    );
  }

  Future<void> checkout({
    required String userId,
    required double currentBtcPrice,
    required Function(Order) onOrderCreated,
  }) async {
    if (_items.isEmpty) return;

    // Group items by storeId
    final Map<String, List<CartItem>> itemsByStore = {};
    for (var item in _items) {
      final storeId = item.product.storeId ?? 'unknown';
      if (!itemsByStore.containsKey(storeId)) {
        itemsByStore[storeId] = [];
      }
      itemsByStore[storeId]!.add(item);
    }

    // Create an order for each store
    for (var entry in itemsByStore.entries) {
      final storeId = entry.key;
      final storeItems = entry.value;

      final orderItems = storeItems.map((item) {
        return OrderItem(
          productId: item.product.id,
          productName: item.product.name,
          quantity: item.quantity,
          pricePerUnit: item.product.getCurrentPrice(currentBtcPrice),
        );
      }).toList();

      final totalAmount = storeItems.fold(0.0, (sum, item) {
        return sum + item.getTotalPrice(currentBtcPrice);
      });

      final order = Order(
        id: const Uuid().v4(),
        clientId: userId,
        storeId: storeId,
        items: orderItems,
        totalPrice: totalAmount,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        btcPriceSnapshot: currentBtcPrice,
      );

      onOrderCreated(order);
    }

    clearCart();
  }
}

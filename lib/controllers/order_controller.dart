import 'package:flutter/material.dart';
import 'package:shop_verse/models/order.dart';

class OrderController extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.from(_orders);

  // Get orders for a specific user (client)
  List<Order> getOrdersByClient(String clientId) {
    return _orders.where((order) => order.clientId == clientId).toList();
  }

  // Get orders for a specific merchant (vendor)
  // Note: This is a bit complex since an order might contain items from multiple vendors.
  // For MVP, we'll assume an order is split or we just filter items.
  // But for now, let's just return all orders for admin/merchant dashboard to filter.

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
      notifyListeners();
    }
  }
}

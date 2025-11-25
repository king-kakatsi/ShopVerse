import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/auth_controller.dart';
import 'package:shop_verse/controllers/order_controller.dart';
import 'package:shop_verse/controllers/store_controller.dart';
import 'package:shop_verse/models/order.dart';
import 'package:timeago/timeago.dart' as timeago;

class MerchantOrdersPage extends StatelessWidget {
  const MerchantOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final orderController = Provider.of<OrderController>(context);
    final storeController = Provider.of<StoreController>(context);

    // Get merchant's store IDs
    final myStoreIds = storeController
        .getStoresByMerchant(authController.currentUser?.id ?? '')
        .map((store) => store.id)
        .toSet();

    // Filter orders for merchant's stores
    final myOrders = orderController.orders
        .where((order) => myStoreIds.contains(order.storeId))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: myOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Orders from customers will appear here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myOrders.length,
              itemBuilder: (context, index) {
                final order = myOrders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(
                        order.status,
                        context,
                      ).withOpacity(0.2),
                      child: Icon(
                        Icons.receipt,
                        color: _getStatusColor(order.status, context),
                      ),
                    ),
                    title: Text(
                      'Order #${order.id.substring(0, 8)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${order.totalPrice.toStringAsFixed(0)} FCFA'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  order.status,
                                  context,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                order.status
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getStatusColor(order.status, context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              timeago.format(order.createdAt),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Items:',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...order.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item.quantity}x ${item.productName}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      '${item.pricePerUnit.toStringAsFixed(0)} FCFA',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${order.totalPrice.toStringAsFixed(0)} FCFA',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              children: [
                                if (order.status == OrderStatus.pending)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      orderController.updateOrderStatus(
                                        order.id,
                                        OrderStatus.confirmed,
                                      );
                                    },
                                    icon: const Icon(Icons.check, size: 16),
                                    label: const Text('Accept'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                if (order.status == OrderStatus.confirmed)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      orderController.updateOrderStatus(
                                        order.id,
                                        OrderStatus.completed,
                                      );
                                    },
                                    icon: const Icon(Icons.done_all, size: 16),
                                    label: const Text('Complete'),
                                  ),
                                if (order.status == OrderStatus.pending ||
                                    order.status == OrderStatus.confirmed)
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      orderController.updateOrderStatus(
                                        order.id,
                                        OrderStatus.cancelled,
                                      );
                                    },
                                    icon: const Icon(Icons.cancel, size: 16),
                                    label: const Text('Cancel'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(OrderStatus status, BuildContext context) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

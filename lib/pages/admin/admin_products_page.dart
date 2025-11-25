import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/asset_controller.dart';
import 'package:shop_verse/controllers/bitcoin_controller.dart';

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final assetController = Provider.of<AssetController>(context);
    final btcController = Provider.of<BitcoinController>(context);
    final products = assetController.assets;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No products found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final currentPrice = product.getCurrentPrice(
                  btcController.currentPrice,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHigh,
                            child: Icon(
                              Icons.shopping_bag,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${currentPrice.toStringAsFixed(0)} FCFA'),
                        const SizedBox(height: 4),
                        Text(
                          'Stock: ${product.quantity} | Vendor: ${product.vendor}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Text('View Details'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Product'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          assetController.removeAsset(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Product deleted')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('View details - Coming soon'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

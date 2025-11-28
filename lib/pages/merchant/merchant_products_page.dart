import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/auth_controller.dart';
import 'package:shop_verse/controllers/asset_controller.dart';
import 'package:shop_verse/controllers/bitcoin_controller.dart';
import 'package:shop_verse/pages/merchant/create_product_page.dart';

class MerchantProductsPage extends StatelessWidget {
  const MerchantProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final assetController = Provider.of<AssetController>(context);
    final btcController = Provider.of<BitcoinController>(context);

    // Filter products by current merchant's vendor name
    final myProducts = assetController.assets
        .where((asset) => asset.vendor == authController.currentUser?.name)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateProductPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: myProducts.isEmpty
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
                    'No products yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first product to start selling',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateProductPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myProducts.length,
              itemBuilder: (context, index) {
                final product = myProducts[index];
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
                        Row(
                          children: [
                            Icon(
                              Icons.inventory,
                              size: 12,
                              color: product.quantity > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Stock: ${product.quantity}',
                              style: TextStyle(
                                fontSize: 12,
                                color: product.quantity > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit Product'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Product'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteDialog(context, assetController, product);
                        } else if (value == 'edit') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Edit - Coming soon')),
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

  void _showDeleteDialog(
    BuildContext context,
    AssetController controller,
    dynamic product,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.removeAsset(product);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Product deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

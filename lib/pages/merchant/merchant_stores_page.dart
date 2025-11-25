import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/auth_controller.dart';
import 'package:shop_verse/controllers/store_controller.dart';
import 'package:shop_verse/pages/merchant/create_store_page.dart';

class MerchantStoresPage extends StatelessWidget {
  const MerchantStoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final storeController = Provider.of<StoreController>(context);
    final myStores = storeController.getStoresByMerchant(
      authController.currentUser?.id ?? '',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateStorePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: myStores.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_mall_directory_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No stores yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first store to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateStorePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Store'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myStores.length,
              itemBuilder: (context, index) {
                final store = myStores[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        store.imageUrl,
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
                              Icons.store,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      store.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: store.isOpen ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              store.isOpen ? 'Open' : 'Closed',
                              style: TextStyle(
                                fontSize: 12,
                                color: store.isOpen ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(
                            store.isOpen ? 'Close Store' : 'Open Store',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit Store'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Store'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'toggle') {
                          storeController.toggleStoreStatus(store.id);
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, storeController, store.id);
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
    StoreController controller,
    String storeId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Store'),
        content: const Text('Are you sure you want to delete this store?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteStore(storeId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Store deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

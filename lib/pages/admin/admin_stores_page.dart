import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/store_controller.dart';

class AdminStoresPage extends StatelessWidget {
  const AdminStoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storeController = Provider.of<StoreController>(context);
    final stores = storeController.allStores;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Stores')),
      body: stores.isEmpty
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
                    'No stores found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
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
                          value: 'delete',
                          child: Text('Delete Store'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'toggle') {
                          storeController.toggleStoreStatus(store.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Store ${store.isOpen ? 'closed' : 'opened'}',
                              ),
                            ),
                          );
                        } else if (value == 'delete') {
                          storeController.deleteStore(store.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Store deleted')),
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

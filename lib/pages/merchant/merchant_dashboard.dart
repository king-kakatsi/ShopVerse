import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/auth_controller.dart';
import 'package:shop_verse/widgets/btc_price_widget.dart';
import 'package:shop_verse/pages/merchant/create_store_page.dart';
import 'package:shop_verse/pages/merchant/create_product_page.dart';

/// Merchant dashboard page
class MerchantDashboard extends StatelessWidget {
  const MerchantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Dashboard'),
        centerTitle: false,
        actions: [
          const BtcPriceWidget(compact: true),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.storefront,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${authController.currentUser?.name}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Merchant',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateStorePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_business),
                    label: const Text('Create Store'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateProductPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add Product'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sections
            Text(
              'My Business',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: [
                  _buildSectionCard(
                    context,
                    icon: Icons.store,
                    title: 'My Stores',
                    subtitle: 'Manage your stores',
                    trailing: '0',
                    onTap: () {
                      // TODO: Navigate to my stores
                    },
                  ),
                  _buildSectionCard(
                    context,
                    icon: Icons.inventory_2,
                    title: 'My Products',
                    subtitle: 'Manage your products',
                    trailing: '0',
                    onTap: () {
                      // TODO: Navigate to my products
                    },
                  ),
                  _buildSectionCard(
                    context,
                    icon: Icons.shopping_cart,
                    title: 'Orders',
                    subtitle: 'View customer orders',
                    trailing: '0',
                    onTap: () {
                      // TODO: Navigate to orders
                    },
                  ),
                  _buildSectionCard(
                    context,
                    icon: Icons.analytics,
                    title: 'Sales Analytics',
                    subtitle: 'View your performance',
                    trailing: '',
                    onTap: () {
                      // TODO: Navigate to analytics
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: trailing.isNotEmpty
            ? Chip(
                label: Text(trailing),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

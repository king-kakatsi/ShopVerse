import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/models/asset.dart';
import 'package:shop_verse/controllers/bitcoin_controller.dart';
import 'package:shop_verse/controllers/cart_controller.dart';
import 'package:shop_verse/controllers/auth_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AssetCard({
    super.key,
    required this.asset,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final btcController = Provider.of<BitcoinController>(context);
    final numberFormat = NumberFormat('#,###', 'fr_FR');

    // Calculate current price based on BTC
    final currentPrice = asset.getCurrentPrice(btcController.currentPrice);
    final priceChange = asset.getPriceChangePercentage(
      btcController.currentPrice,
    );

    // Determine price change color
    Color priceColor;
    if (priceChange > 0.1) {
      priceColor = Colors.green;
    } else if (priceChange < -0.1) {
      priceColor = Colors.red;
    } else {
      priceColor = Theme.of(context).colorScheme.primary;
    }

    final authController = Provider.of<AuthController>(context);
    final cartController = Provider.of<CartController>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Icon + Name/Quantity + Price
            Row(
              children: [
                // Crypto Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      asset.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.currency_bitcoin,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12),

                // Name and Quantity
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Quantity ${asset.quantity}\$',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price with BTC adjustment
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${numberFormat.format(currentPrice.round())} F',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: priceColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (priceChange.abs() > 0.1)
                      Text(
                        '${priceChange > 0 ? '+' : ''}${priceChange.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: priceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 4),

            // Symbol
            Row(
              children: [
                SizedBox(width: 72), // Align with name (icon width + spacing)
                Text(
                  asset.symbol,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            SizedBox(height: 12),

            // Additional info
            _buildInfoRow(context, 'Network', asset.network),
            SizedBox(height: 8),
            _buildInfoRow(context, 'Payment', asset.paymentMethod),
            SizedBox(height: 8),
            _buildInfoRow(context, 'Seller', asset.vendor),

            SizedBox(height: 16),

            // Bottom row: Timestamp + Actions
            Row(
              children: [
                // Timestamp
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 4),
                    Text(
                      timeago.format(asset.createdAt, locale: 'en_short'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                Spacer(),

                if (authController.isClient)
                  ElevatedButton.icon(
                    onPressed: () {
                      cartController.addToCart(asset);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${asset.name} added to cart'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),

                if (authController.isAdmin ||
                    (authController.isMerchant &&
                        asset.vendor == authController.currentUser?.name)) ...[
                  // Edit button
                  IconButton(
                    icon: Icon(Icons.edit_note),
                    iconSize: 22,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: onEdit ?? () {},
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                  ),

                  SizedBox(width: 8),

                  // Delete button
                  IconButton(
                    icon: Icon(Icons.delete_sweep),
                    iconSize: 22,
                    color: Theme.of(context).colorScheme.error,
                    onPressed: onDelete ?? () {},
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(width: 16),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

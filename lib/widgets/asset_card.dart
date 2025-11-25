import 'package:flutter/material.dart';
import 'package:shop_verse/models/asset.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Quantité ${asset.quantity}\$',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                Text(
                  '${asset.price.toStringAsFixed(1)} FCFA / 1\$',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4),

            // Symbol and Prix label
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
                SizedBox(width: 24),
                Text(
                  'Prix',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            _buildInfoRow(context, 'Crypto network', asset.network),
            SizedBox(height: 8),
            _buildInfoRow(context, 'Mobile money', asset.paymentMethod),
            SizedBox(height: 8),
            _buildInfoRow(context, 'Vendeur', asset.vendor),

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

                // Edit button
                IconButton(
                  icon: Icon(Icons.edit_outlined),
                  iconSize: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  onPressed: onEdit ?? () {},
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(),
                ),

                SizedBox(width: 8),

                // Delete button
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  iconSize: 20,
                  color: Theme.of(context).colorScheme.error,
                  onPressed: onDelete ?? () {},
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(),
                ),
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

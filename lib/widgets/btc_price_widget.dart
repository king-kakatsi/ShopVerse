import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/bitcoin_controller.dart';
import 'package:intl/intl.dart';

/// Widget displaying real-time Bitcoin price with trend indicator
class BtcPriceWidget extends StatelessWidget {
  final bool compact;

  const BtcPriceWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final btcController = Provider.of<BitcoinController>(context);
    final numberFormat = NumberFormat('#,###', 'fr_FR');

    if (btcController.isLoading && btcController.currentPrice == 0) {
      return _buildLoadingState();
    }

    if (btcController.error != null && btcController.currentPrice == 0) {
      return _buildErrorState(btcController.error!);
    }

    final trendColor = btcController.getTrendColor();
    final trendIcon = btcController.getTrendIcon();

    if (compact) {
      return _buildCompactView(
        btcController,
        numberFormat,
        trendColor,
        trendIcon,
      );
    }

    return _buildFullView(
      context,
      btcController,
      numberFormat,
      trendColor,
      trendIcon,
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Loading BTC...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 14, color: Colors.red),
          SizedBox(width: 6),
          Text(
            'BTC Error',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactView(
    BitcoinController btcController,
    NumberFormat numberFormat,
    Color trendColor,
    IconData trendIcon,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: trendColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(trendIcon, size: 14, color: trendColor),
          SizedBox(width: 6),
          Text(
            '${numberFormat.format(btcController.currentPrice.round())} F',
            style: TextStyle(
              color: trendColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullView(
    BuildContext context,
    BitcoinController btcController,
    NumberFormat numberFormat,
    Color trendColor,
    IconData trendIcon,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            trendColor.withValues(alpha: 0.3),
            trendColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: trendColor.withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.currency_bitcoin, color: trendColor, size: 24),
              SizedBox(width: 8),
              Text(
                'Bitcoin Price',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: trendColor,
                ),
              ),
              Spacer(),
              Icon(trendIcon, color: trendColor, size: 20),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '${numberFormat.format(btcController.currentPrice.round())} FCFA',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: trendColor,
            ),
          ),
          SizedBox(height: 4),
          if (btcController.changePercentage != 0)
            Text(
              '${btcController.changePercentage > 0 ? '+' : ''}${btcController.changePercentage.toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: trendColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (btcController.lastUpdate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Updated: ${TimeOfDay.fromDateTime(btcController.lastUpdate!).format(context)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

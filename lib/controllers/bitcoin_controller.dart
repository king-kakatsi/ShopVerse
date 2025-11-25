import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop_verse/services/bitcoin_service.dart';

/// Enum representing Bitcoin price trend
enum PriceTrend {
  up, // Price increased
  down, // Price decreased
  stable, // Price unchanged or minimal change
}

/// Controller for managing Bitcoin price state with 30-second polling
class BitcoinController extends ChangeNotifier {
  final BitcoinService _bitcoinService = BitcoinService();

  // Current Bitcoin price in FCFA
  double _currentPrice = 0.0;
  double get currentPrice => _currentPrice;

  // Previous price for comparison
  double _previousPrice = 0.0;

  // Current price trend
  PriceTrend _trend = PriceTrend.stable;
  PriceTrend get trend => _trend;

  // Price change percentage
  double _changePercentage = 0.0;
  double get changePercentage => _changePercentage;

  // Last update timestamp
  DateTime? _lastUpdate;
  DateTime? get lastUpdate => _lastUpdate;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _error;
  String? get error => _error;

  // Timer for 30-second polling
  Timer? _pollingTimer;

  // Price update lock (prevents multiple updates in same cycle)
  bool _updateLocked = false;

  /// Initialize and start polling
  Future<void> init() async {
    await fetchPrice();
    startPolling();
  }

  /// Start 30-second polling
  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => fetchPrice(),
    );
  }

  /// Stop polling
  void stopPolling() {
    _pollingTimer?.cancel();
  }

  /// Fetch current Bitcoin price
  Future<void> fetchPrice() async {
    if (_updateLocked) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final price = await _bitcoinService.getCurrentPrice();

      if (price != null) {
        _updateLocked = true;

        // Store previous price
        _previousPrice = _currentPrice;
        _currentPrice = price;
        _lastUpdate = DateTime.now();

        // Calculate trend and percentage change
        if (_previousPrice > 0) {
          final change = _currentPrice - _previousPrice;
          _changePercentage = (change / _previousPrice) * 100;

          // Determine trend (threshold: 0.1%)
          if (_changePercentage > 0.1) {
            _trend = PriceTrend.up;
          } else if (_changePercentage < -0.1) {
            _trend = PriceTrend.down;
          } else {
            _trend = PriceTrend.stable;
          }
        }

        _isLoading = false;
        notifyListeners();

        // Unlock after notification
        Future.delayed(const Duration(milliseconds: 100), () {
          _updateLocked = false;
        });
      } else {
        _error = 'Failed to fetch Bitcoin price';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get color based on trend
  Color getTrendColor() {
    switch (_trend) {
      case PriceTrend.up:
        return Colors.green;
      case PriceTrend.down:
        return Colors.red;
      case PriceTrend.stable:
        return Colors.amber;
    }
  }

  /// Get trend icon
  IconData getTrendIcon() {
    switch (_trend) {
      case PriceTrend.up:
        return Icons.trending_up;
      case PriceTrend.down:
        return Icons.trending_down;
      case PriceTrend.stable:
        return Icons.trending_flat;
    }
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}

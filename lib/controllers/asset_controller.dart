import 'package:flutter/material.dart';
import 'package:shop_verse/models/asset.dart';

class AssetController extends ChangeNotifier {
  List<Asset> _allAssets = [];
  List<Asset> assets = [];

  AssetController() {
    initialize();
  }

  void initialize() {
    // Dummy data for now
    _allAssets = [
      Asset(
        id: '1',
        name: 'Bitcoin',
        symbol: 'BTC',
        price: 95000.0,
        imageUrl: 'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
        description: 'The original cryptocurrency.',
        quantity: 100,
        network: 'BEP20 (BSC)',
        paymentMethod: 'Momo (VODAPHONE)',
        vendor: 'user1',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      Asset(
        id: '2',
        name: 'Ethereum',
        symbol: 'ETH',
        price: 3500.0,
        imageUrl: 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
        description: 'The smart contract platform.',
        quantity: 500,
        network: 'ERC20 (ETH)',
        paymentMethod: 'Momo (MTN)',
        vendor: 'user2',
        createdAt: DateTime.now().subtract(Duration(days: 240)),
      ),
      Asset(
        id: '3',
        name: 'Solana',
        symbol: 'SOL',
        price: 150.0,
        imageUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
        description: 'High performance blockchain.',
        quantity: 200,
        network: 'SPL (Solana)',
        paymentMethod: 'Orange Money',
        vendor: 'user3',
        createdAt: DateTime.now().subtract(Duration(days: 7)),
      ),
    ];
    assets = List.from(_allAssets);
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      assets = List.from(_allAssets);
    } else {
      assets = _allAssets.where((asset) {
        return asset.name.toLowerCase().contains(query.toLowerCase()) ||
            asset.symbol.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void addAsset(Asset asset) {
    _allAssets.add(asset);
    search(''); // Reset filter
  }

  void removeAsset(Asset asset) {
    _allAssets.removeWhere((a) => a.id == asset.id);
    search(''); // Reset filter
  }
}

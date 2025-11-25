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
      ),
      Asset(
        id: '2',
        name: 'Ethereum',
        symbol: 'ETH',
        price: 3500.0,
        imageUrl: 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
        description: 'The smart contract platform.',
      ),
      Asset(
        id: '3',
        name: 'Solana',
        symbol: 'SOL',
        price: 150.0,
        imageUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
        description: 'High performance blockchain.',
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

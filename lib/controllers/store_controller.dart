import 'package:flutter/material.dart';
import 'package:shop_verse/models/store.dart';

/// Controller for managing stores (mock data for now)
class StoreController extends ChangeNotifier {
  List<Store> _allStores = [];
  List<Store> get allStores => List.from(_allStores);

  // Stores filtered by merchant
  List<Store> getStoresByMerchant(String merchantId) {
    return _allStores.where((store) => store.merchantId == merchantId).toList();
  }

  // Get single store by ID
  Store? getStoreById(String id) {
    try {
      return _allStores.firstWhere((store) => store.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new store
  void addStore(Store store) {
    _allStores.add(store);
    notifyListeners();
  }

  /// Update existing store
  void updateStore(Store updatedStore) {
    final index = _allStores.indexWhere((s) => s.id == updatedStore.id);
    if (index != -1) {
      _allStores[index] = updatedStore;
      notifyListeners();
    }
  }

  /// Delete store
  void deleteStore(String id) {
    _allStores.removeWhere((store) => store.id == id);
    notifyListeners();
  }

  /// Toggle store open/closed status
  void toggleStoreStatus(String id) {
    final index = _allStores.indexWhere((s) => s.id == id);
    if (index != -1) {
      _allStores[index] = _allStores[index].copyWith(
        isOpen: !_allStores[index].isOpen,
      );
      notifyListeners();
    }
  }
}

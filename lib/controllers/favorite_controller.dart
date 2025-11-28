import 'package:flutter/material.dart';
import 'package:shop_verse/models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Controller for managing user's favorite stores
class FavoriteController extends ChangeNotifier {
  final List<String> _favoriteStoreIds = [];
  final Map<String, Store> _favoriteStores = {};

  List<Store> get favoriteStores => _favoriteStores.values.toList();
  List<String> get favoriteStoreIds => List.from(_favoriteStoreIds);

  /// Check if a store is favorited
  bool isFavorite(String storeId) {
    return _favoriteStoreIds.contains(storeId);
  }

  /// Initialize favorites from local storage
  Future<void> init(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'favorites_$userId';
      final storedIds = prefs.getStringList(key) ?? [];

      _favoriteStoreIds.clear();
      _favoriteStoreIds.addAll(storedIds);

      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  /// Add store to favorites
  Future<void> addFavorite(Store store, String userId) async {
    if (!_favoriteStoreIds.contains(store.id)) {
      _favoriteStoreIds.add(store.id);
      _favoriteStores[store.id] = store;

      await _saveFavorites(userId);
      notifyListeners();
    }
  }

  /// Remove store from favorites
  Future<void> removeFavorite(String storeId, String userId) async {
    if (_favoriteStoreIds.contains(storeId)) {
      _favoriteStoreIds.remove(storeId);
      _favoriteStores.remove(storeId);

      await _saveFavorites(userId);
      notifyListeners();
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(Store store, String userId) async {
    if (isFavorite(store.id)) {
      await removeFavorite(store.id, userId);
    } else {
      await addFavorite(store, userId);
    }
  }

  /// Update favorite store data (when store info changes)
  void updateFavoriteStore(Store store) {
    if (_favoriteStoreIds.contains(store.id)) {
      _favoriteStores[store.id] = store;
      notifyListeners();
    }
  }

  /// Clear all favorites
  Future<void> clearFavorites(String userId) async {
    _favoriteStoreIds.clear();
    _favoriteStores.clear();

    await _saveFavorites(userId);
    notifyListeners();
  }

  /// Save favorites to local storage
  Future<void> _saveFavorites(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'favorites_$userId';
      await prefs.setStringList(key, _favoriteStoreIds);
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  /// Get favorite count
  int get favoriteCount => _favoriteStoreIds.length;

  /// Check if favorites is empty
  bool get isEmpty => _favoriteStoreIds.isEmpty;
}

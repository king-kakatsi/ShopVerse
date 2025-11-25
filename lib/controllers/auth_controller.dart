import 'package:flutter/material.dart';
import 'package:shop_verse/models/user.dart';
import 'package:shop_verse/services/mock_auth_service.dart';

/// Authentication controller for managing user session
class AuthController extends ChangeNotifier {
  final MockAuthService _authService = MockAuthService();

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  UserRole? get userRole => _currentUser?.role;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);

      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  /// Check if user is admin
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  /// Check if user is merchant
  bool get isMerchant => _currentUser?.isMerchant ?? false;

  /// Check if user is client
  bool get isClient => _currentUser?.isClient ?? false;
}

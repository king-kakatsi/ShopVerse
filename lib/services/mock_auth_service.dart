import 'package:shop_verse/models/user.dart';

/// Mock authentication service for development without Firebase
class MockAuthService {
  // Hardcoded mock users for testing
  static final List<User> _mockUsers = [
    // Admin user
    User(
      id: 'admin1',
      email: 'admin@shopverse.com',
      name: 'Admin User',
      role: UserRole.admin,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),

    // Merchant users
    User(
      id: 'merchant1',
      email: 'merchant1@shopverse.com',
      name: 'John Merchant',
      role: UserRole.merchant,
      latitude: 3.8480,
      longitude: 11.5021, // Yaoundé coordinates
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
    ),
    User(
      id: 'merchant2',
      email: 'merchant2@shopverse.com',
      name: 'Marie Commerçante',
      role: UserRole.merchant,
      latitude: 4.0511,
      longitude: 9.7679, // Douala coordinates
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),

    // Client users
    User(
      id: 'client1',
      email: 'client1@shopverse.com',
      name: 'Alice Client',
      role: UserRole.client,
      latitude: 3.8667,
      longitude: 11.5167,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    User(
      id: 'client2',
      email: 'client2@shopverse.com',
      name: 'Bob Acheteur',
      role: UserRole.client,
      latitude: 4.0483,
      longitude: 9.7043,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  /// Login with email (password ignored for mock)
  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Find user by email
    try {
      return _mockUsers.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Logout (no-op for mock)
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// Get all users (for admin)
  List<User> getAllUsers() {
    return List.from(_mockUsers);
  }

  /// Get users by role
  List<User> getUsersByRole(UserRole role) {
    return _mockUsers.where((user) => user.role == role).toList();
  }
}

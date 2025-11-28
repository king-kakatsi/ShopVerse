import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User roles in ShopVerse
enum UserRole { admin, merchant, client }

/// User model
@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final double? latitude; // GPS location
  final double? longitude;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is merchant
  bool get isMerchant => role == UserRole.merchant;

  /// Check if user is client
  bool get isClient => role == UserRole.client;
}

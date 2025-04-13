import 'package:flutter/foundation.dart';

class ProfileResponse {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileResponse({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    debugPrint("📥 Parsing ProfileResponse: $json");

    return ProfileResponse(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? "Unknown",
      email: json['email']?.toString() ?? "-",
      emailVerifiedAt: json['email_verified_at']?.toString(),
      role: json['role']?.toString(),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// **Helper function untuk parsing tanggal**
  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      debugPrint("⚠️ Gagal parsing tanggal: $date");
      return null;
    }
  }
}

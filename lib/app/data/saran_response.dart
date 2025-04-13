import 'package:flutter/foundation.dart';

class SaranResponse {
  final bool success;
  final String message;
  final List<Saran> data;

  SaranResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SaranResponse.fromJson(Map<String, dynamic> json) {
    debugPrint("📥 Parsing SaranResponse: $json");

    return SaranResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? "Unknown",
      data: (json['data'] as List<dynamic>? ?? [])
          .map((v) => Saran.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((v) => v.toJson()).toList(),
    };
  }
}

class Saran {
  final int id;
  final String nama;
  final String email;
  final String judul;
  final String deskripsi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Saran({
    required this.id,
    required this.nama,
    required this.email,
    required this.judul,
    required this.deskripsi,
    this.createdAt,
    this.updatedAt,
  });

  factory Saran.fromJson(Map<String, dynamic> json) {
    debugPrint("📥 Parsing Saran: $json");

    return Saran(
      id: json['id'] as int? ?? 0,
      nama: json['nama']?.toString() ?? "Unknown",
      email: json['email']?.toString() ?? "-",
      judul: json['judul']?.toString() ?? "-",
      deskripsi: json['deskripsi']?.toString() ?? "-",
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'judul': judul,
      'deskripsi': deskripsi,
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

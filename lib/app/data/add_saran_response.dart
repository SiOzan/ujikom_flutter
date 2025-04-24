import 'package:flutter/foundation.dart';

class AddSaranResponse {
  final bool success;
  final String message;
  final Saran data;

  AddSaranResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AddSaranResponse.fromJson(Map<String, dynamic> json) {
    debugPrint("📥 Parsing AddSaranResponse: $json");

    return AddSaranResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? "Unknown",
      data: Saran.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
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

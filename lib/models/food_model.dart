import 'dart:convert';

class FoodModel {
  final int id;
  final String nama;
  final String deskripsi;
  final List<String> panduan;
  final double? totalKalori;
  final double? totalKarbohidrat;
  final double? totalLemak;
  final double? kadarGula;
  final List<String> bahan;
  final List<String> tips;
  final String? gambar;
  final DateTime createdAt;
  final DateTime updatedAt;

  FoodModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.panduan,
    this.totalKalori,
    this.totalKarbohidrat,
    this.totalLemak,
    this.kadarGula,
    required this.bahan,
    required this.tips,
    this.gambar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic input) {
      if (input == null) return [];
      if (input is List) return List<String>.from(input);
      if (input is String) {
        try {
          final decoded = jsonDecode(input);
          if (decoded is List) {
            return List<String>.from(decoded);
          }
        } catch (_) {}
      }
      return [];
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return FoodModel(
      id: json['id'],
      nama: json['nama'] ?? "",
      deskripsi: json['deskripsi'] ?? "",
      panduan: parseStringList(json['panduan']),
      totalKalori: parseDouble(json['total_kalori']),
      totalKarbohidrat: parseDouble(json['total_karbohidrat']),
      totalLemak: parseDouble(json['total_lemak']),
      kadarGula: parseDouble(json['kadar_gula']),
      bahan: parseStringList(json['bahan']),
      tips: parseStringList(json['tips']),
      gambar: json['foto_url'], // sudah berisi URL lengkap dari Laravel
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'panduan': panduan,
      'total_kalori': totalKalori,
      'total_karbohidrat': totalKarbohidrat,
      'total_lemak': totalLemak,
      'kadar_gula': kadarGula,
      'bahan': bahan,
      'tips': tips,
      'gambar': gambar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Optional getter kalau kamu masih ingin pakai nama lain
  String? get fotoUrl => gambar;
}

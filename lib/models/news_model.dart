import 'package:sweetsense/constants/constants.dart';

class NewsModel {
  final int id;
  final String judul;
  final String deskripsi;
  final String sumber;
  final String penulis;
  final String kategori;
  final String? gambar;
  final String link;
  final DateTime tanggalterbit;
  final DateTime createdAt;
  final DateTime updatedAt;

  NewsModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.sumber,
    required this.penulis,
    required this.kategori,
    required this.gambar,
    required this.link,
    required this.tanggalterbit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: _parseId(json['id']),
      judul: json['judul']?.toString() ?? "",
      deskripsi: json['deskripsi']?.toString() ?? "",
      sumber: json['sumber']?.toString() ?? "",
      penulis: json['penulis']?.toString() ?? "",
      kategori: json['kategori']?.toString() ?? "",
      gambar: json['gambar']?.toString(),
      link: json['link']?.toString() ?? "",
      tanggalterbit: _parseDateTime(json['tanggalterbit']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  // Helper function untuk parsing ID
  static int _parseId(dynamic value) {
    if (value == null) {
      throw Exception('ID tidak boleh null');
    }
    if (value is int) {
      return value;
    }
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    throw Exception(
        'ID harus berupa integer, diterima: $value (${value.runtimeType})');
  }

  // Helper function untuk parsing DateTime
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'sumber': sumber,
      'penulis': penulis,
      'kategori': kategori,
      'gambar': gambar,
      'link': link,
      'tanggalterbit': tanggalterbit.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// URL gambar yang sudah lengkap
  String? get fotoUrl {
    if (gambar == null || gambar!.isEmpty) return null;
    if (gambar!.startsWith('http')) return gambar;
    return '${url.replaceFirst('/api/v1', '/storage/')}$gambar';
  }
}

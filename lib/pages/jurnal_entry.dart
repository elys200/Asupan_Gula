// models/jurnal_entry.dart
import 'dart:ui';

class JurnalEntry {
  final String tanggal;
  final String waktuMakan;
  final String jam;
  final List<MakananItem> makananList;
  final double totalKalori;
  final double totalGula;
  final double totalKarbo;
  final double totalLemak;
  final String status;
  final Color statusColor;

  JurnalEntry({
    required this.tanggal,
    required this.waktuMakan,
    required this.jam,
    required this.makananList,
    required this.totalKalori,
    required this.totalGula,
    required this.totalKarbo,
    required this.totalLemak,
    required this.status,
    required this.statusColor,
  });

  // Convert to Map for easier handling
  Map<String, dynamic> toMap() {
    return {
      'tanggal': tanggal,
      'waktuMakan': waktuMakan,
      'jam': jam,
      'makananList': makananList.map((item) => item.toMap()).toList(),
      'kalori': totalKalori.toStringAsFixed(0),
      'gula': totalGula.toStringAsFixed(0),
      'karbo': totalKarbo.toStringAsFixed(0),
      'lemak': totalLemak.toStringAsFixed(0),
      'status': status,
      'statusColor': statusColor,
    };
  }
}

class MakananItem {
  final String nama;
  final String jumlah;
  final double jumlahAngka;
  final double kalori;
  final double gula;
  final double protein;
  final double lemak;
  final double karbohidrat;

  MakananItem({
    required this.nama,
    required this.jumlah,
    required this.jumlahAngka,
    required this.kalori,
    required this.gula,
    this.protein = 0.0,
    this.lemak = 0.0,
    this.karbohidrat = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jumlah': jumlah,
      'jumlahAngka': jumlahAngka,
      'kalori': kalori,
      'gula': gula,
      'protein': protein,
      'lemak': lemak,
      'karbohidrat': karbohidrat,
    };
  }

  factory MakananItem.fromMap(Map<String, dynamic> map) {
    return MakananItem(
      nama: map['nama'] ?? '',
      jumlah: map['jumlah'] ?? '',
      jumlahAngka: (map['jumlahAngka'] ?? 0.0).toDouble(),
      kalori: (map['kalori'] ?? 0.0).toDouble(),
      gula: (map['gula'] ?? 0.0).toDouble(),
      protein: (map['protein'] ?? 0.0).toDouble(),
      lemak: (map['lemak'] ?? 0.0).toDouble(),
      karbohidrat: (map['karbohidrat'] ?? 0.0).toDouble(),
    );
  }
}
// services/jurnal_service.dart
import 'package:flutter/material.dart';
import 'jurnal_entry.dart';

class JurnalService {
  static final JurnalService _instance = JurnalService._internal();
  factory JurnalService() => _instance;
  JurnalService._internal();

  // Mulai dengan list kosong
  final List<JurnalEntry> _jurnalEntries = [];

  List<JurnalEntry> get jurnalEntries => List.unmodifiable(_jurnalEntries);

  void addJurnalEntry(JurnalEntry entry) {
    _jurnalEntries.insert(0, entry); // Tambah di awal list (terbaru)
  }

  void removeJurnalEntry(int index) {
    if (index >= 0 && index < _jurnalEntries.length) {
      _jurnalEntries.removeAt(index);
    }
  }

  // Fungsi untuk menentukan status berdasarkan total gula
  static String getStatusFromGula(double totalGula) {
    if (totalGula < 15) {
      return 'Low';
    } else if (totalGula <= 25) {
      return 'Normal';
    } else {
      return 'High';
    }
  }

  // Fungsi untuk mendapatkan warna status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Low':
        return Colors.yellow;
      case 'Normal':
        return Colors.green;
      case 'High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


}
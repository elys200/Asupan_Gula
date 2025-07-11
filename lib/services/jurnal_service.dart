import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jurnal_entry.dart';
import '../constants/constants.dart';

class JurnalApiService {
  final String token;

  JurnalApiService({required this.token});

  /// Menambahkan jurnal baru ke backend.
  /// Mengirim data jurnal (dari model `JurnalEntry`) untuk user tertentu.
  Future<void> tambahJurnal(JurnalEntry entry, int userId) async {
    final uri = Uri.parse('${url}jurnal');

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(entry.toLaravelPayload(userId)),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
          'Gagal menyimpan jurnal: ${response.statusCode}\n${response.body}');
    }
  }

  /// Mengambil daftar jurnal milik user tertentu dari backend.
  /// Return: List<JurnalEntry>
  Future<List<JurnalEntry>> fetchJurnal(int userId) async {
    final uri = Uri.parse('${url}jurnal?user_id=$userId');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => JurnalEntry.fromMap(e)).toList();
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
    }
  }

  /// Menghapus jurnal berdasarkan id.
  Future<void> hapusJurnal(int id) async {
    final uri = Uri.parse('${url}jurnal/$id');

    final response = await http.delete(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Gagal menghapus jurnal: ${response.statusCode}\n${response.body}');
    }
  }

  /// Menambahkan jurnal dengan data minimal:
  /// tanggal, waktu makan, total gula, dan user id.
  Future<void> tambahJurnalMinimal({
    required String tanggal,
    required String waktuMakan,
    required double totalGula,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('${url}jurnal'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'date': tanggal,
        'waktu_makan': waktuMakan,
        'total_gula': totalGula,
        'user_id': userId,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
          'Gagal simpan jurnal: ${response.statusCode}\n${response.body}');
    }
  }

  /// Menambahkan jurnal dengan data lengkap:
  /// termasuk kalori, karbohidrat, lemak, jam, dll.
  Future<void> tambahJurnalLengkap({
    required String tanggal,
    required String waktuMakan,
    required double totalGula,
    required double totalKalori,
    required double totalKarbo,
    required double totalLemak,
    required String jam,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('${url}jurnal'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'date': tanggal,
        'waktu_makan': waktuMakan,
        'total_gula': totalGula,
        'total_kalori': totalKalori,
        'total_karbo': totalKarbo,
        'total_lemak': totalLemak,
        'jam': jam,
        'user_id': userId,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
          'Gagal simpan jurnal lengkap: ${response.statusCode}\n${response.body}');
    }
  }
}

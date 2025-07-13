import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jurnal_entry.dart';
import '../constants/constants.dart';

class JurnalResult {
  final List<JurnalEntry> entries;
  final int total;
  final int currentPage;
  final int lastPage;

  JurnalResult({
    required this.entries,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
}

class JurnalApiService {
  final String token;

  JurnalApiService({required this.token});

  /// Fetch jurnal entries with pagination
  Future<JurnalResult> fetchJurnal(
    int userId, {
    int page = 1,
    int perPage = 10,
  }) async {
    final uri =
        Uri.parse('${url}jurnal?user_id=$userId&page=$page&per_page=$perPage');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map && data.containsKey('data')) {
        final List<dynamic> rawEntries = data['data'] ?? [];
        final entries = rawEntries.map((e) => JurnalEntry.fromMap(e)).toList();

        return JurnalResult(
          entries: entries,
          total: data['total'] ?? entries.length,
          currentPage: data['current_page'] ?? 1,
          lastPage: data['last_page'] ?? 1,
        );
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception(
          'Failed to fetch jurnal: ${response.statusCode}\n${response.body}');
    }
  }

  /// Add a complete jurnal entry
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
          'Failed to save jurnal: ${response.statusCode}\n${response.body}');
    }
  }

  /// Delete a jurnal entry
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
          'Failed to delete jurnal: ${response.statusCode}\n${response.body}');
    }
  }

  /// Save a minimal jurnal entry
  Future<void> tambahJurnalMinimal({
    required String tanggal,
    required String waktuMakan,
    required double totalGula,
    required int userId,
  }) async {
    final uri = Uri.parse('${url}jurnal');

    final payload = {
      'date': tanggal,
      'waktu_makan': waktuMakan,
      'total_gula': totalGula,
      'user_id': userId,
    };

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
          'Failed to save minimal jurnal: ${response.statusCode}\n${response.body}');
    }
  }

  /// Save a fully detailed jurnal entry
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
    final uri = Uri.parse('${url}jurnal');

    final payload = {
      'date': tanggal,
      'waktu_makan': waktuMakan,
      'total_gula': totalGula,
      'total_kalori': totalKalori,
      'total_karbo': totalKarbo,
      'total_lemak': totalLemak,
      'jam': jam,
      'user_id': userId,
    };

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
          'Failed to save complete jurnal: ${response.statusCode}\n${response.body}');
    }
  }
}

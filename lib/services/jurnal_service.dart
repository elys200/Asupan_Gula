import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jurnal_entry.dart';
import '../constants/constants.dart';

// Model hasil response API jurnal (dengan pagination)
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

// Service untuk komunikasi ke API jurnal
class JurnalApiService {
  /// token autentikasi (bisa diubah setelah login)
  String token;

  JurnalApiService({required this.token});

  // Ambil data jurnal dari API (dengan pagination)
  Future<JurnalResult> fetchJurnal(
    int userId, {
    int page = 1,
    int perPage = 10,
  }) async {
    final uri = Uri.parse('${url}jurnal/user?page=$page&per_page=$perPage');

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
          currentPage: page,
          lastPage: (data['total'] / perPage).ceil(),
        );
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception(
          'Failed to fetch jurnal: ${response.statusCode}\n${response.body}');
    }
  }

  // Tambah entry jurnal baru ke API
  Future<void> tambahJurnal(JurnalEntry entry, int userId) async {
    final uri = Uri.parse('${url}jurnal/user');

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
}

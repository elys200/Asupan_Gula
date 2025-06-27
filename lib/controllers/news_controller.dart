import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/news_model.dart';

class NewsController {
  // Mendapatkan semua berita
  static Future<List<NewsModel>> getAllNews() async {
    final uri = Uri.parse('${url}berita-all');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List<dynamic> jsonList =
          body is List ? body : body['data'] ?? body['berita'] ?? [];

      return jsonList.map((json) => NewsModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat daftar berita');
    }
  }

  // Mendapatkan satu berita berdasarkan ID
  static Future<NewsModel> getNewsById(int id) async {
    final uri = Uri.parse('${url}berita/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final Map<String, dynamic> jsonData = body is Map<String, dynamic>
          ? (body['id'] != null ? body : body['data'] ?? body['berita'] ?? {})
          : {};

      if (jsonData.isEmpty || jsonData['id'] == null) {
        throw Exception('ID berita tidak ditemukan dalam response');
      }

      return NewsModel.fromJson(jsonData);
    } else {
      throw Exception('Gagal memuat detail berita dengan ID $id');
    }
  }
}

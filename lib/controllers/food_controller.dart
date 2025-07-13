import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/food_model.dart';

class FoodController {
  // Ambil semua resep makanan (untuk halaman food)
  static Future<List<FoodModel>> getAllFoods() async {
    final uri = Uri.parse('${url}resep-all');
    final response = await http.get(uri);

    print('getAllFoods status: ${response.statusCode}');
    print('body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> dataList =
          responseData is List ? responseData : responseData['data'] ?? [];

      return dataList.map((jsonItem) => FoodModel.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Gagal memuat daftar resep makanan');
    }
  }

  // Ambil satu resep makanan berdasarkan ID
  static Future<FoodModel> getFoodById(int id) async {
    final uri = Uri.parse('${url}resep/$id');
    final response = await http.get(uri);

    print('getFoodById status: ${response.statusCode}');
    print('body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final Map<String, dynamic> data = jsonData is Map<String, dynamic>
          ? (jsonData['id'] != null ? jsonData : jsonData['data'] ?? {})
          : {};

      if (data.isEmpty || data['id'] == null) {
        throw Exception('Format data tidak sesuai');
      }

      return FoodModel.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail resep dengan ID $id');
    }
  }

  // Ambil 3 resep terbaru untuk dashboard
  static Future<List<FoodModel>> getTop3Foods() async {
    final uri = Uri.parse('${url}resep-terbaru');
    final response = await http.get(uri);

    print('getTop3Foods status: ${response.statusCode}');
    print('body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> dataList =
          responseData is List ? responseData : responseData['data'] ?? [];

      return dataList.map((jsonItem) => FoodModel.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Gagal memuat 3 resep terbaru');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/food_model.dart';

class FoodController {
  // Ambil semua resep makanan (untuk halaman food)
  static Future<List<FoodModel>> getAllFoods() async {
    final uri = Uri.parse('${url}resep-all');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> dataList = jsonDecode(response.body);
      return dataList.map((jsonItem) => FoodModel.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Gagal memuat daftar resep makanan');
    }
  }

  // Ambil satu resep makanan berdasarkan ID
  static Future<FoodModel> getFoodById(int id) async {
    final uri = Uri.parse('${url}resep/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Ambil hanya bagian "data" dari respons API
      if (jsonData.containsKey('data')) {
        return FoodModel.fromJson(jsonData['data']);
      } else {
        throw Exception('Format data tidak sesuai');
      }
    } else {
      throw Exception('Gagal memuat detail resep dengan ID $id');
    }
  }

  // Tambahan: Ambil 3 resep terbaru untuk dashboard
  static Future<List<FoodModel>> getTop3Foods() async {
    final uri = Uri.parse('${url}resep-terbaru');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> dataList = jsonDecode(response.body);
      return dataList.map((jsonItem) => FoodModel.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Gagal memuat 3 resep terbaru');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/food_model.dart';

class FoodController {
  // Mendapatkan semua resep makanan
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

  // Mendapatkan satu resep makanan berdasarkan ID
  static Future<FoodModel> getFoodById(int id) async {
    final uri = Uri.parse('${url}resep/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return FoodModel.fromJson(jsonData);
    } else {
      throw Exception('Gagal memuat detail resep dengan ID $id');
    }
  }
}

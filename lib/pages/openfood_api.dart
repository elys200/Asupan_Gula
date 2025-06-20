import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodData {
  final String nama;
  final double kalori;
  final double gula;
  final double protein;
  final double lemak;
  final double karbohidrat;

  FoodData({
    required this.nama,
    required this.kalori,
    required this.gula,
    required this.protein,
    required this.lemak,
    required this.karbohidrat,
  });
}

class OpenFoodFactsAPI {
  static Future<FoodData?> fetchNutrisiMakanan(String makanan) async {
    final url = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$makanan&search_simple=1&json=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = data['products'];

        if (products != null && products.isNotEmpty) {
          final product = products[0];
          final nutriments = product['nutriments'] ?? {};

          return FoodData(
            nama: product['product_name'] ?? makanan,
            kalori: (nutriments['energy-kcal_100g'] ?? 0).toDouble(),
            gula: (nutriments['sugars_100g'] ?? 0).toDouble(),
            protein: (nutriments['proteins_100g'] ?? 0).toDouble(),
            lemak: (nutriments['fat_100g'] ?? 0).toDouble(),
            karbohidrat: (nutriments['carbohydrates_100g'] ?? 0).toDouble(),
          );
        }
      }
    } catch (e) {
      // Jika terjadi kesalahan saat memanggil API
      print('Terjadi kesalahan saat memuat data nutrisi: $e');
    }

    return null;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'openfood_api.dart'; // untuk menggunakan NutrisiModel
import 'package:flutter_dotenv/flutter_dotenv.dart';

class USDAApi {
  // Gunakan API key dari .env file, fallback ke hardcoded jika tidak ada
  static String get apiKey {
    try {
      return dotenv.env['USDA_API_KEY'] ?? '3w1fYhlbyCQjO1COmlYfYDVas83awJOyZGcG8U2Q';
    } catch (e) {
      // Jika dotenv belum diinisialisasi atau file tidak ada
      return '3w1fYhlbyCQjO1COmlYfYDVas83awJOyZGcG8U2Q';
    }
  }

  static const String baseUrl = 'https://api.nal.usda.gov/fdc/v1';
  static const int timeoutSeconds = 10;

  static Future<NutrisiModel?> fetchNutrisiMakanan(String namaMakanan) async {
    try {
      // Validasi input
      final cleanedQuery = namaMakanan.trim();
      if (cleanedQuery.isEmpty) {
        print('❌ Nama makanan tidak boleh kosong');
        return null;
      }

      // Encode URL untuk menangani karakter khusus
      final encodedQuery = Uri.encodeComponent(cleanedQuery);
      final searchUrl = '$baseUrl/foods/search?query=$encodedQuery&api_key=$apiKey&pageSize=25';

      print('🔍 Mencari "$namaMakanan" di USDA API...');
      
      final response = await http.get(
        Uri.parse(searchUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['foods'] != null && data['foods'].isNotEmpty) {
          // Cari makanan yang paling relevan
          final foods = data['foods'] as List;
          Map<String, dynamic>? bestMatch;
          double bestScore = 0.0;

          for (final food in foods) {
            final description = (food['description'] ?? '').toString().toLowerCase();
            final searchTerm = cleanedQuery.toLowerCase();
            
            // Hitung skor relevansi
            double score = 0.0;
            if (description.contains(searchTerm)) {
              score += 10.0;
              if (description.startsWith(searchTerm)) {
                score += 5.0;
              }
            }

            // Prioritaskan makanan dengan data nutrisi yang lengkap
            final nutrients = food['foodNutrients'] as List?;
            if (nutrients != null && nutrients.isNotEmpty) {
              score += 2.0;
              
              // Bonus untuk nutrisi penting
              final importantNutrients = [
                'Energy', 'Protein', 'Total lipid (fat)', 
                'Carbohydrate, by difference', 'Sugars, total including NLEA'
              ];
              
              for (final nutrient in nutrients) {
                final nutrientName = nutrient['nutrientName']?.toString() ?? '';
                if (importantNutrients.any((important) => 
                    nutrientName.toLowerCase().contains(important.toLowerCase()))) {
                  score += 1.0;
                }
              }
            }

            if (score > bestScore) {
              bestScore = score;
              bestMatch = food;
            }
          }

          if (bestMatch != null && bestScore > 0) {
            print('✅ Ditemukan: ${bestMatch['description']} (Score: $bestScore)');
            
            return NutrisiModel(
              nama: bestMatch['description']?.toString() ?? namaMakanan,
              kalori: _getNutrient(bestMatch, [
                "Energy",
                "Energy (Atwater General Factors)",
                "Energy (Atwater Specific Factors)"
              ]),
              gula: _getNutrient(bestMatch, [
                "Sugars, total including NLEA",
                "Sugars, total",
                "Total Sugars"
              ]),
              protein: _getNutrient(bestMatch, [
                "Protein",
                "Protein (N x 6.25)"
              ]),
              lemak: _getNutrient(bestMatch, [
                "Total lipid (fat)",
                "Fat, total",
                "Total Fat"
              ]),
              karbohidrat: _getNutrient(bestMatch, [
                "Carbohydrate, by difference",
                "Total carbohydrate",
                "Carbohydrates"
              ]),
            );
          }
        }
        
        print('❌ Tidak ditemukan data untuk "$namaMakanan"');
        return null;

      } else if (response.statusCode == 403) {
        print('❌ API Key tidak valid atau limit tercapai');
        return null;
      } else if (response.statusCode == 429) {
        print('❌ Terlalu banyak request, coba lagi nanti');
        return null;
      } else {
        print('❌ Error HTTP ${response.statusCode}: ${response.body}');
        return null;
      }

    } on SocketException {
      print('❌ Tidak ada koneksi internet');
      return null;
    } on http.ClientException catch (e) {
      print('❌ Error koneksi: $e');
      return null;
    } on FormatException catch (e) {
      print('❌ Error parsing JSON: $e');
      return null;
    } catch (e) {
      print('❌ Error umum USDA API: $e');
      return null;
    }
  }

  // Helper method untuk mencari nutrisi dengan berbagai nama alternatif
  static double _getNutrient(Map<String, dynamic> food, List<String> nutrientNames) {
    try {
      final nutrients = food['foodNutrients'] as List?;
      if (nutrients == null) return 0.0;

      for (final nutrientName in nutrientNames) {
        final nutrient = nutrients.firstWhere(
          (n) => n['nutrientName']?.toString().toLowerCase() == nutrientName.toLowerCase(),
          orElse: () => null,
        );

        if (nutrient != null) {
          final value = nutrient['value'];
          if (value != null) {
            final doubleValue = double.tryParse(value.toString()) ?? 0.0;
            if (doubleValue.isFinite && doubleValue >= 0) {
              return doubleValue;
            }
          }
        }
      }

      // Fallback: cari berdasarkan substring
      for (final nutrientName in nutrientNames) {
        final nutrient = nutrients.firstWhere(
          (n) => n['nutrientName']?.toString().toLowerCase().contains(nutrientName.toLowerCase()) == true,
          orElse: () => null,
        );

        if (nutrient != null) {
          final value = nutrient['value'];
          if (value != null) {
            final doubleValue = double.tryParse(value.toString()) ?? 0.0;
            if (doubleValue.isFinite && doubleValue >= 0) {
              return doubleValue;
            }
          }
        }
      }

    } catch (e) {
      print('⚠️ Error mengambil nutrisi ${nutrientNames.first}: $e');
    }
    
    return 0.0;
  }

  // Method untuk testing koneksi API
  static Future<bool> testConnection() async {
    try {
      final testUrl = '$baseUrl/foods/search?query=apple&api_key=$apiKey&pageSize=1';
      final response = await http.get(Uri.parse(testUrl))
          .timeout(Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Test koneksi USDA API gagal: $e');
      return false;
    }
  }
}
import 'package:openfoodfacts/openfoodfacts.dart';

class NutrisiModel {
  final String nama;
  final double kalori;
  final double gula;
  final double protein;
  final double lemak;
  final double karbohidrat;

  NutrisiModel({
    required this.nama,
    required this.kalori,
    required this.gula,
    required this.protein,
    required this.lemak,
    required this.karbohidrat,
  });

  @override
  String toString() {
    return 'NutrisiModel(nama: $nama, kalori: $kalori, gula: $gula, protein: $protein, lemak: $lemak, karbohidrat: $karbohidrat)';
  }
}

class OpenFoodFactsAPI {
  static Future<NutrisiModel?> fetchNutrisiMakanan(String namaMakanan) async {
    try {
      // Bersihkan input
      final cleanedQuery = namaMakanan.trim().toLowerCase();
      if (cleanedQuery.isEmpty) {
        print('❌ Nama makanan tidak boleh kosong');
        return null;
      }

      final List<OpenFoodFactsLanguage> bahasaPrioritas = [
        OpenFoodFactsLanguage.ENGLISH,
        OpenFoodFactsLanguage.INDONESIAN,
        OpenFoodFactsLanguage.SPANISH,
      ];

      for (final bahasa in bahasaPrioritas) {
        print('🔍 Mencari "$namaMakanan" dalam bahasa ${bahasa.code.toUpperCase()}');

        try {
          final query = ProductSearchQueryConfiguration(
            parametersList: <Parameter>[
              SearchTerms(terms: [cleanedQuery]),
            ],
            language: bahasa,
            fields: [
              ProductField.NAME,
              ProductField.NUTRIMENTS,
              ProductField.BRANDS,
              ProductField.INGREDIENTS,
            ],
            version: ProductQueryVersion.v3,
          );

          final result = await OpenFoodAPIClient.searchProducts(null, query);

          if (result.products != null && result.products!.isNotEmpty) {
            // Cari produk yang paling relevan
            Product? bestMatch;
            double bestScore = 0.0;

            for (final product in result.products!) {
              final productName = (product.productName ?? '').toLowerCase();
              final brands = (product.brands ?? '').toLowerCase();
              final searchTerm = cleanedQuery.toLowerCase();

              // Hitung skor relevansi
              double score = 0.0;
              if (productName.contains(searchTerm)) {
                score += 10.0;
                if (productName.startsWith(searchTerm)) {
                  score += 5.0;
                }
              }
              if (brands.contains(searchTerm)) {
                score += 3.0;
              }

              // Prioritaskan produk yang memiliki data nutrisi lengkap
              if (product.nutriments != null) {
                final nutriments = product.nutriments!;
                if (nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams) != null) score += 2.0;
                if (nutriments.getValue(Nutrient.sugars, PerSize.oneHundredGrams) != null) score += 1.0;
                if (nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams) != null) score += 1.0;
                if (nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams) != null) score += 1.0;
                if (nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams) != null) score += 1.0;
              }

              if (score > bestScore) {
                bestScore = score;
                bestMatch = product;
              }
            }

            if (bestMatch != null && bestScore > 0) {
              final nutriments = bestMatch.nutriments;
              
              print('✅ Ditemukan: ${bestMatch.productName} (Score: $bestScore)');

              return NutrisiModel(
                nama: bestMatch.productName ?? namaMakanan,
                kalori: _getNutrientValue(nutriments, Nutrient.energyKCal),
                gula: _getNutrientValue(nutriments, Nutrient.sugars),
                protein: _getNutrientValue(nutriments, Nutrient.proteins),
                lemak: _getNutrientValue(nutriments, Nutrient.fat),
                karbohidrat: _getNutrientValue(nutriments, Nutrient.carbohydrates),
              );
            }
          }
        } catch (e) {
          print('❌ Error saat mencari dalam ${bahasa.code}: $e');
          continue;
        }

        print('❌ Tidak ditemukan untuk "$namaMakanan" dalam ${bahasa.code.toUpperCase()}');
      }

      print('❌ Produk tidak ditemukan di semua bahasa');
      return null;

    } catch (e) {
      print('❌ Error umum OpenFoodFacts API: $e');
      return null;
    }
  }

  // Helper method untuk mendapatkan nilai nutrisi dengan error handling
  static double _getNutrientValue(Nutriments? nutriments, Nutrient nutrient) {
    try {
      final value = nutriments?.getValue(nutrient, PerSize.oneHundredGrams);
      if (value != null && value.isFinite && value >= 0) {
        return value.toDouble();
      }
    } catch (e) {
      print('⚠️ Error mengambil nilai ${nutrient.offTag}: $e');
    }
    return 0.0;
  }
}
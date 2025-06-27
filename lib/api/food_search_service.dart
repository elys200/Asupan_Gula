// food_search_service.dart

import 'package:sweetsense/api/openfood_api.dart';
import 'package:sweetsense/api/usda_api.dart';

class FoodSearchService {
  static Future<NutrisiModel?> cariDataNutrisi(String namaMakanan) async {
    // 1. Coba cari dari OpenFoodFacts
    final dariOFF = await OpenFoodFactsAPI.fetchNutrisiMakanan(namaMakanan);
    if (dariOFF != null) {
      print('✅ Ditemukan dari OpenFoodFacts: ${dariOFF.nama}');
      return dariOFF;
    }

    // 2. Jika tidak ditemukan, coba cari dari USDA
    final dariUSDA = await USDAApi.fetchNutrisiMakanan(namaMakanan);
    if (dariUSDA != null) {
      print('✅ Ditemukan dari USDA: ${dariUSDA.nama}');
      return dariUSDA;
    }

    // 3. Tidak ditemukan di kedua API
    print('❌ Tidak ditemukan dari OFF maupun USDA');
    return null;
  }
}

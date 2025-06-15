import 'package:get/get.dart';
import '../models/favorite_recipe_model.dart';
import '../constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteRecipeController extends GetxController {
  var favoriteIds = <int>{}.obs;
  var favorites = <FavoriteRecipeModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  String? userToken;

  void setToken(String token) {
    userToken = token;
  }

  Future<void> fetchFavorites() async {
    if (userToken == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final uri = Uri.parse('${url}resep-favorit');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<FavoriteRecipeModel> fetchedFavorites = data
            .map((json) => FavoriteRecipeModel.fromJson(json))
            .where((item) => item.resep != null)
            .toList();

        favorites.assignAll(fetchedFavorites);
        final newIds = fetchedFavorites.map((item) => item.resep!.id).toSet();
        favoriteIds
          ..clear()
          ..addAll(newIds);
      } else {
        errorMessage.value = 'Gagal mengambil data: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    }

    isLoading.value = false;
  }

  Future<void> toggleFavorite(int resepId) async {
    if (userToken == null) return;

    try {
      final uri = Uri.parse('${url}resep-favorit/toggle');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'resep_id': resepId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (favoriteIds.contains(resepId)) {
          favoriteIds.remove(resepId);

          // Hapus dari daftar favorites agar langsung hilang dari UI
          favorites.removeWhere((item) => item.resep?.id == resepId);
        } else {
          favoriteIds.add(resepId);

          // Tambah data baru ke favorites jika ada dalam response
          final data = jsonDecode(response.body);
          if (data['data'] != null) {
            favorites.add(FavoriteRecipeModel.fromJson(data['data']));
          }
        }
      } else {
        print("Toggle gagal: ${response.body}");
      }
    } catch (e) {
      print("Toggle error: $e");
    }
  }

  bool isFavorited(int resepId) => favoriteIds.contains(resepId);
}

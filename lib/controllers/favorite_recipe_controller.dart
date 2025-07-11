import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  Future<void> toggleFavorite(
    int resepId, {
    bool showUnfavoriteNotice = true,
  }) async {
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
          // Unfavorite
          favoriteIds.remove(resepId);
          favorites.removeWhere((item) => item.resep?.id == resepId);

          if (showUnfavoriteNotice) {
            _showPopupCustom(
              title: 'Dihapus!',
              text: 'Resep telah dihapus dari favorit ❌',
              isFavorite: false,
            );
          }
        } else {
          // Favorite
          favoriteIds.add(resepId);

          final data = jsonDecode(response.body);
          if (data['data'] != null) {
            favorites.add(FavoriteRecipeModel.fromJson(data['data']));
          }

          _showPopupCustom(
            title: 'Favorit!',
            text: 'Resep telah ditambahkan ke favorit dengan bintang ✨',
            isFavorite: true,
          );
        }
      } else {
        print("Toggle gagal: ${response.body}");
      }
    } catch (e) {
      print("Toggle error: $e");
    }
  }

  /// Cek apakah resep sedang difavoritkan
  bool isFavorited(int resepId) {
    return favoriteIds.contains(resepId);
  }

  void _showPopupCustom({
    required String title,
    required String text,
    required bool isFavorite,
  }) {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Lottie.asset(
                  isFavorite
                      ? 'assets/star.json' // animasi saat favorite
                      : 'assets/unfavorite.json', // animasi saat unfavorite
                  repeat: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isFavorite ? Colors.amber : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          content: Text(text),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isFavorite ? Colors.amber : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(Get.context!).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      Get.snackbar(title, text);
    }
  }
}

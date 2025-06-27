import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/favorite_recipe_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/food_model.dart';
import 'food_detail.dart';

class FavoriteRecipe extends StatefulWidget {
  const FavoriteRecipe({super.key});

  @override
  State<FavoriteRecipe> createState() => _FavoriteRecipeState();
}

class _FavoriteRecipeState extends State<FavoriteRecipe> {
  final favoriteController = Get.put(FavoriteRecipeController());
  final profileController = Get.put(ProfileController());
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _initFavorites();
    profileController.fetchProfile();
  }

  Future<void> _initFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      favoriteController.setToken(token);
      await favoriteController.fetchFavorites();
    } else {
      print("Token tidak ditemukan.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchField(),
            Expanded(child: _buildFavoriteGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final user = profileController.user.value;
      return Container(
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.of(context).padding.top + 20,
          20,
          20,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE43A15), Color(0xFFE65245)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Hi, ${user?.username ?? 'User'}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage:
                  user?.fotoUrl != null && user!.fotoUrl!.isNotEmpty
                      ? NetworkImage(user.fotoUrl!)
                      : const AssetImage('assets/images/portrait.png')
                          as ImageProvider,
              radius: 18,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: TextField(
          onChanged: (value) => setState(() => searchQuery = value),
          decoration: const InputDecoration(
            hintText: "Search food",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteGrid() {
    return Obx(() {
      if (favoriteController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final filtered = favoriteController.favorites.where((fav) {
        final nama = fav.resep?.nama.toLowerCase() ?? '';
        return nama.contains(searchQuery.toLowerCase());
      }).toList();

      if (filtered.isEmpty) {
        return const Center(child: Text("Tidak ada resep favorit."));
      }

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            return FoodCard(food: filtered[index].resep!);
          },
        ),
      );
    });
  }
}

class FoodCard extends StatelessWidget {
  final FoodModel food;
  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteRecipeController>();

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  food.fotoUrl ?? 'https://via.placeholder.com/150',
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  food.nama,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${food.totalKalori?.toStringAsFixed(0) ?? '0'} kcal",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FoodDetailPage(food: food),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE43A15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "More Detail",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Obx(() {
            final isFavorited = favoriteController.isFavorited(food.id);
            return InkWell(
              onTap: () => favoriteController.toggleFavorite(food.id),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  isFavorited ? Icons.star : Icons.star_border,
                  color: isFavorited ? Colors.amber : Colors.grey,
                  size: 24,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

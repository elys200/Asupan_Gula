import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'food_detail.dart';
import '../controllers/food_controller.dart';
import '../controllers/favorite_recipe_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/food_model.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FoodPage(),
    );
  }
}

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final favoriteController = Get.put(FavoriteRecipeController());
  final profileController = Get.put(ProfileController());

  List<FoodModel> foodList = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initFavorites();
    fetchFoods();
    profileController.fetchProfile();
  }

  Future<void> _initFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      favoriteController.setToken(token);
      favoriteController.fetchFavorites();
    }
  }

  Future<void> fetchFoods() async {
    final foods = await FoodController.getAllFoods();
    setState(() {
      foodList = foods;
      isLoading = false;
    });
  }

  List<FoodModel> get filteredFoodList => searchQuery.isEmpty
      ? foodList
      : foodList
          .where((food) =>
              food.nama.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

  Widget _buildAvatarPlaceholder({double radius = 18}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: radius, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // ✅ prevent layout from shifting
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context)
                    .unfocus(), // ✅ dismiss keyboard on tap
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: filteredFoodList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) => FoodCard(
                            food: filteredFoodList[index],
                            favoriteController: favoriteController,
                          ),
                        ),
                      ),
              ),
            ),
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
            20, MediaQuery.of(context).padding.top + 20, 20, 20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                if (user?.fotoUrl != null && user!.fotoUrl!.isNotEmpty)
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: CachedNetworkImageProvider(user.fotoUrl!),
                  )
                else
                  _buildAvatarPlaceholder(radius: 18),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Find your food",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildSearchField(),
          ],
        ),
      );
    });
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final FoodModel food;
  final FavoriteRecipeController favoriteController;

  const FoodCard({
    super.key,
    required this.food,
    required this.favoriteController,
  });

  @override
  Widget build(BuildContext context) {
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
                child: CachedNetworkImage(
                  imageUrl: food.fotoUrl ?? 'https://via.placeholder.com/150',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  food.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${food.totalKalori?.toStringAsFixed(0) ?? '0'} kcal",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailPage(food: food),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE43A15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "More Detail",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
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
              onTap: () async {
                await favoriteController.toggleFavorite(food.id);
                await favoriteController.fetchFavorites();
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  isFavorited ? Icons.star : Icons.star_border,
                  color: isFavorited ? Colors.amber : Colors.white,
                  size: 22,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

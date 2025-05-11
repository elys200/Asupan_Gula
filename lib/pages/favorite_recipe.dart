// Nama File: favorite_recipe.dart
// Deskripsi: Menampilkan koleksi resep favorit pengguna dengan header gradient dan grid interaktif
// Dibuat oleh: Jihan Safinatunnaja - NIM: 3312301065
// Tanggal: 6 May 2024

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Konfigurasi status bar transparan secara global
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FavoriteRecipe(),
    );
  }
}

class FavoriteRecipe extends StatelessWidget {
  const FavoriteRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        // Nonaktifkan safe area untuk fullscreen design
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Header dengan gradient
            _buildGradientHeader(context),
            
            // Grid makanan
            _buildRecipeGrid(),
          ],
        ),
      ),
    );
  }

  // Membangun header dengan gradient dan search bar
  Widget _buildGradientHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        // Menambahkan tinggi status bar ke padding atas
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
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris navigasi dan profil
          _buildTopBar(context),
          
          // Judul halaman
          const SizedBox(height: 20),
          const Text(
            "Find your favorite recipe",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          // Search bar
          const SizedBox(height: 20),
          _buildSearchBar(),
        ],
      ),
    );
  }

  // Membangun bar navigasi atas
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Tombol kembali
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        
        const SizedBox(width: 10),
        // Nama pengguna
        const Text(
          "Hi Elys",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Spacer untuk mengisi ruang kosong
        const Spacer(),
        
        // Avatar pengguna
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/portrait.png'),
          radius: 18,
        ),
      ],
    );
  }

  // Membangun search bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search food",
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  // Membangun grid resep
  Widget _buildRecipeGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) => const FoodCard(),
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar makanan
          _buildFoodImage(),
          
          // Detail makanan
          _buildFoodDetails(),
        ],
      ),
    );
  }

  // Membangun gambar makanan
  Widget _buildFoodImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: Image.asset(
        'assets/images/food2.png',
        height: 110,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  // Membangun detail makanan
  Widget _buildFoodDetails() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama makanan
          Text(
            "Vegetable salad",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
          ),
          
          // Baris kalori dan tombol
          SizedBox(height: 5),
          _buildCalorieButtonRow(),
        ],
      ),
    );
  }
}

// Baris kalori dan tombol detail
class _buildCalorieButtonRow extends StatelessWidget {
  const _buildCalorieButtonRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Jumlah kalori
        const Text(
          "220 kcal",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        
        // Tombol detail
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE43A15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "More Detail",
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ],
    );
  }
}
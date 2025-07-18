import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:sweetsense/models/news_model.dart';

// Import halaman
import 'package:sweetsense/pages/landing_page.dart';
import 'package:sweetsense/pages/onboarding_screen.dart';
import 'package:sweetsense/pages/onboarding_screen2.dart';
import 'package:sweetsense/pages/onboarding_screen3.dart';
import 'package:sweetsense/pages/perhitungan_gula.dart';
import 'package:sweetsense/pages/welcome.dart';
import 'package:sweetsense/pages/register.dart';
import 'package:sweetsense/pages/login.dart';
import 'package:sweetsense/pages/dashboard.dart';
import 'package:sweetsense/pages/profile.dart';
import 'package:sweetsense/pages/edit_profile.dart';
import 'package:sweetsense/pages/change_password.dart';
import 'package:sweetsense/pages/favorite_recipe.dart';
import 'package:sweetsense/pages/food.dart';
import 'package:sweetsense/pages/news.dart';
import 'package:sweetsense/pages/food_detail.dart';
import 'package:sweetsense/pages/news_detail.dart';
import 'package:sweetsense/pages/jurnal.dart';

// Import controller
import 'package:sweetsense/controllers/authentication.dart';
import 'package:sweetsense/controllers/profile_controller.dart';
import 'package:sweetsense/controllers/food_controller.dart';
import 'package:sweetsense/controllers/favorite_recipe_controller.dart';
import 'package:sweetsense/controllers/news_controller.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Pastikan flutter binding siap
  WidgetsFlutterBinding.ensureInitialized();
  print('✅ Flutter binding initialized');

  try {
    await dotenv.load(fileName: ".env");
    print('✅ .env loaded');
  } catch (e) {
    print('❌ Failed loading .env: $e');
  }

  Get.put(AuthenticationController());
  Get.put(ProfileController());
  Get.put(FavoriteRecipeController());
  Get.put(FoodController());
  Get.put(NewsController());
  print('✅ Controllers initialized');

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    print('🔥 Flutter Error: ${details.exception}');
    print(details.stack);
  };

  runZonedGuarded(() {
    runApp(const SweetSense());
  }, (error, stack) {
    print('🚨 Uncaught Zone Error: $error');
    print(stack);
  });
}

class SweetSense extends StatelessWidget {
  const SweetSense({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sweet Sense',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LandingPage()),
        GetPage(
            name: '/onboarding_screen', page: () => const OnboardingScreen()),
        GetPage(
            name: '/onboarding_screen2', page: () => const OnboardingScreen2()),
        GetPage(
            name: '/onboarding_screen3', page: () => const OnboardingScreen3()),
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),

        // Curved Navigation Pages
        GetPage(
            name: '/perhitungan_gula',
            page: () => const MainWithCurvedNav(initialIndex: 0)),
        GetPage(
            name: '/dashboard',
            page: () => const MainWithCurvedNav(initialIndex: 1)),
        GetPage(
            name: '/profile',
            page: () => const MainWithCurvedNav(initialIndex: 2)),

        // Other Pages
        GetPage(name: '/edit_profile', page: () => const EditProfilePage()),
        GetPage(
            name: '/change_password', page: () => const ChangePasswordPage()),
        GetPage(name: '/favorite_recipe', page: () => const FavoriteRecipe()),
        GetPage(name: '/food', page: () => const FoodPage()),
        GetPage(name: '/news', page: () => const NewsPage()), 
        GetPage(name: '/jurnal', page: () => const JurnalPage()),

        //  Detail Pages
        GetPage(
            name: '/food_detail',
            page: () => FoodDetailPage(food: Get.arguments)),
        GetPage(
          name: '/news_detail',
          page: () => NewsDetailPage(news: Get.arguments as NewsModel),
        ),
      ],
    );
  }
}

// Navbar Curved Navigation
class MainWithCurvedNav extends StatefulWidget {
  final int initialIndex;
  const MainWithCurvedNav({super.key, this.initialIndex = 0});

  @override
  _MainWithCurvedNavState createState() => _MainWithCurvedNavState();
}

class _MainWithCurvedNavState extends State<MainWithCurvedNav> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    PerhitunganGulaPage(),
    DashboardScreen(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: const [
          Icon(Icons.calculate, size: 30, color: Colors.white),
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        color: const Color(0xFFE43A15),
        buttonBackgroundColor: const Color(0xFFE43A15),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

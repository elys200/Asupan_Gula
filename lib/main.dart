import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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

void main() {
  runApp(const SweetSense());
}

class SweetSense extends StatelessWidget {
  const SweetSense({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sweet Sense',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/onboarding_screen': (context) => const OnboardingScreen(),
        '/onboarding_screen2': (context) => const OnboardingScreen2(),
        '/onboarding_screen3': (context) => const OnboardingScreen3(),
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/perhitungan_gula':
            (context) => const MainWithCurvedNav(initialIndex: 0),
        '/dashboard': (context) => const MainWithCurvedNav(initialIndex: 1),
        '/profile': (context) => const MainWithCurvedNav(initialIndex: 2),
        '/edit_profile': (context) => const EditProfilePage(),
        '/change_password': (context) => const ChangePasswordPage(),
        '/favorite_recipe': (context) => const FavoriteRecipe(),
        '/food': (context) => const FoodPage(),
        '/news': (context) => const NewsPage(),
      },
    );
  }
}

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
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.calculate, size: 30, color: Colors.white),
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        color: const Color(0xFFE43A15),
        buttonBackgroundColor: const Color(0xFFE43A15),
        backgroundColor: Colors.transparent,
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

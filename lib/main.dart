import 'package:flutter/material.dart';
import 'package:sweetsense/dashboard.dart';
import 'package:sweetsense/onboarding_screen.dart';
import 'package:sweetsense/onboarding_screen2.dart';
import 'package:sweetsense/welcome.dart';
import 'package:sweetsense/register.dart';
import 'package:sweetsense/login.dart';
import 'landing_page.dart';
import 'onboarding_screen3.dart';
import 'food.dart';
import 'news.dart';

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
        '/': (context) => LandingPage(),
        '/onboarding_screen': (context) => OnboardingScreen(),
        '/onboarding_screen2': (context) => OnboardingScreen2(),
        '/onboarding_screen3': (context) => OnboardingScreen3(),
        '/welcome': (context) => WelcomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/food': (context) => FoodPage(),
        '/news': (context) => NewsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

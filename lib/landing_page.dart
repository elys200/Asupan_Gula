import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 233, 99, 66), Color(0xFFD32F2F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/images/landing_image2.png', width: 250),
                const SizedBox(height: 40),
                const Text(
                  'Balance your\nsugar\nBoost your Life',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 52,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/onboarding_screen');
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text(
                      'Get Started',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

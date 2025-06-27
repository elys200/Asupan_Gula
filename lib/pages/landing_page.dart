import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE43A15), Color(0xFFE65245)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Hanya logo (tanpa teks)
              Center(
                child: Image.asset(
                  'assets/images/logo_sweetsense.png',
                  width: 400,
                  height: 400,
                ),
              ),

              const Spacer(),

              // Tombol Get Started di kiri bawah
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 20, bottom: 200),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/onboarding_screen');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Get Started',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size

    return Scaffold(
      backgroundColor: const Color(0xFFFF3D00),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/orang3.png',
                    height: size.height * 0.35,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dot(isActive: false),
                      _dot(isActive: false),
                      _dot(isActive: true),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Keep Healthy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Work-Life Balance',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          'Menjaga keseimbangan antara pekerjaan dan gaya hidup sehat dimulai dari kebiasaan kecil, termasuk mengatur pola makan. Asupan gula yang terkontrol membantu tubuh tetap bugar, pikiran lebih fokus, dan produktivitas tetap terjaga sepanjang hari.',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/welcome');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3D00),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 10 : 6,
      height: isActive ? 10 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white60,
        shape: BoxShape.circle,
      ),
    );
  }
}

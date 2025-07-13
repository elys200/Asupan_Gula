import 'package:flutter/material.dart';
import 'dart:math';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sweepAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _sweepAnimation = Tween<double>(
      begin: 0.0,
      end: 4 * pi / 3, // 240 derajat
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              height: size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF512F), Color(0xFFFF3D00)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Gambar karakter
            Positioned(
              top: size.height * 0.14,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/orang2.png',
                  height: size.height * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Container putih bagian bawah
            Positioned(
              top: size.height * 0.42,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.58,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Keep Healthy',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Work-Life Balance',
                      style: TextStyle(
                        fontSize: 26,
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
                  ],
                ),
              ),
            ),

            // Tombol next dengan arc animated
            Positioned(
              bottom: 40,
              right: 24,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: AnimatedArcPainter(sweep: _sweepAnimation.value),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/onboarding_screen3');
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF3D00),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter untuk animasi arc
class AnimatedArcPainter extends CustomPainter {
  final double sweep;

  AnimatedArcPainter({required this.sweep});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF3D00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: 35,
    );

    const double startAngle = -pi / 2; // dari atas
    canvas.drawArc(rect, startAngle, sweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant AnimatedArcPainter oldDelegate) {
    return oldDelegate.sweep != sweep;
  }
}

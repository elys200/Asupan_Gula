import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final int progressStep;

  const OnboardingScreen({super.key, this.progressStep = 1});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sweepAnimation;

  double getTargetSweepAngle(int step) {
    switch (step) {
      case 1:
        return 2 * 3.1416 / 3; // 120 derajat
      case 2:
        return 4 * 3.1416 / 3; // 240 derajat
      case 3:
        return 2 * 3.1416; // 360 derajat (penuh)
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final targetAngle = getTargetSweepAngle(widget.progressStep);

    _sweepAnimation = Tween<double>(begin: 0, end: targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

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
            // Background
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

            // Image
            Positioned(
              top: size.height * 0.14,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/orang${widget.progressStep}.png',
                  height: size.height * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Content
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
                    const Text('Keep Healthy',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const Text('Work-Life Balance',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
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

            // Dot indikator
            Positioned(
              top: size.height * 0.6,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(isActive: widget.progressStep == 1),
                  _dot(isActive: widget.progressStep == 2),
                  _dot(isActive: widget.progressStep == 3),
                ],
              ),
            ),

            // Tombol Next dengan Arc
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
                      animation: _sweepAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: CircularArcPainter(
                            sweepAngle: _sweepAnimation.value,
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.progressStep == 1) {
                        Navigator.pushNamed(context, '/onboarding_screen2');
                      } else if (widget.progressStep == 2) {
                        Navigator.pushNamed(context, '/onboarding_screen3');
                      } else {
                        Navigator.pushNamed(context, '/home');
                      }
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

// Painter dengan sweep angle dari animasi
class CircularArcPainter extends CustomPainter {
  final double sweepAngle;

  CircularArcPainter({required this.sweepAngle});

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

    const double startAngle = -1.57; // dari atas

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CircularArcPainter oldDelegate) =>
      oldDelegate.sweepAngle != sweepAngle;
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Custom painter untuk menggambar bentuk latar belakang putih khusus
class WhiteBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    // Path yang mendefinisikan bentuk kurva kompleks
    final path = Path();
    path.moveTo(0.375, 74.3318);
    path.cubicTo(0.375, 24.1157, 53.3441, -8.44395, 98.1495, 14.2307);
    path.cubicTo(118.386, 24.4717, 142.417, 23.8415, 162.089, 12.554);
    path.lineTo(165.519, 10.5857);
    path.cubicTo(206.68, -13.0325, 259.144, 7.22347, 273.753, 52.3746);
    path.lineTo(283.931, 83.829);
    path.cubicTo(292.011, 108.8, 289.114, 136.027, 275.96, 158.739);
    path.cubicTo(257.417, 190.754, 221.595, 208.657, 184.859, 204.269);
    path.lineTo(67.1779, 190.213);
    path.cubicTo(57.7307, 189.085, 48.5805, 186.187, 40.2053, 181.673);
    path.cubicTo(15.6716, 168.449, 0.375, 142.827, 0.375, 114.956);
    path.lineTo(0.375, 74.3318);
    path.close();

    // Menggambar path ke canvas dengan paint yang telah didefinisikan
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Dekorasi latar belakang dengan gradien warna
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE43A15), Color(0xFFE65245)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Latar belakang putih dengan bentuk khusus menggunakan custom painter
              Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: const Offset(37, 90),
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 274 * 0.75),
                    painter: WhiteBackgroundPainter(),
                  ),
                ),
              ),

              // Konten utama halaman
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 75),

                      // Gambar untuk halaman landing page
                      Image.asset(
                        'assets/images/landing_image.png',
                        width: double.infinity,
                        height: 212,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 60),

                      // Teks judul
                      Text(
                        'Balance your\nsugar\nBoost your Life',
                        style: GoogleFonts.inknutAntiqua(
                          fontSize: 38,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          height: 1.3,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black26,
                              offset: Offset(0, 4.0),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Tombol aksi "Get Started"
                      ElevatedButton(
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

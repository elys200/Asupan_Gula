import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFF3D00),
      body: SafeArea(
        child: Column(
          children: [
            // Top curve and image
            ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                color: Colors.white,
                height: size.height * 0.4,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/welcome.png',
                  height: size.height * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title Texts
            Text(
              'WELCOME TO',
              style: GoogleFonts.inknutAntiqua(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'SweetSense',
              style: GoogleFonts.inknutAntiqua(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Swipe Less Sugar, Feel More Life',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.04,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 40.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('Register'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text('Login'),
                      ),
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

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

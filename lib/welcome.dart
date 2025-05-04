import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF3D00),
      body: Column(
        children: [
          ClipPath(
            clipper: BottomCurveClipper(),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.center,
              child: Image.asset('assets/images/welcome.png', height: 500),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'WELCOME TO',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'SweetSense',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Swipe Less Sugar, Feel More Life',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 80.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
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
              ],
            ),
          ),
        ],
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

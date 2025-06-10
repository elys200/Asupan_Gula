import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for a fully responsive layout
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        // Set fit to expand to make the Stack fill the entire screen
        fit: StackFit.expand,
        children: [
          // Top background curve - now responsive
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                height: screenHeight * 0.1, // Responsive height
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE43A15), Color(0xFFE65245)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/images/food3.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),

          // Bottom background curve - now responsive and fixed
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: screenHeight * 0.2, // Responsive height
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE43A15), Color(0xFFE65245)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/images/food3.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),

          // Main content - now fully responsive
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06), // Responsive padding
              child: SingleChildScrollView( // Allows content to scroll
                // Added padding to prevent content from scrolling under the bottom curve
                padding: EdgeInsets.only(bottom: screenHeight * 0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: screenHeight * 0.1), // Responsive spacing
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08, // Responsive font size
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04), // Responsive spacing
                    const CustomTextField(hint: 'Username'),
                    SizedBox(height: screenHeight * 0.025), // Responsive spacing
                    const CustomTextField(hint: 'Password', obscureText: true),
                    SizedBox(height: screenHeight * 0.05), // Responsive spacing
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                         Navigator.pushNamed(context, '/dashboard');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5858),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.2, // Responsive padding
                            vertical: screenHeight * 0.018, // Responsive padding
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive radius
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.04, // Responsive font size
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025), // Responsive spacing
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Don’t have an account yet? ",
                            style: TextStyle(fontSize: screenWidth * 0.035), // Responsive font size
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.035, // Responsive font size
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Text Field Widget - now responsive
class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hint,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // Responsive padding
          vertical: screenHeight * 0.02, // Responsive padding
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05), // Responsive radius
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05), // Responsive radius
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }
}

// Smaller Top Curve Clipper (from your login.dart)
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 5);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 10, // slight dip
      size.width,
      size.height - 5,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Bottom Curve Clipper (from your login.dart)
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.4,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.36,
      size.width * 0.65,
      size.height * 0.35,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.5,
      size.width,
      size.height,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for a fully responsive layout
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        // UPDATED: Set fit to expand to make the Stack fill the entire screen.
        // This ensures the Positioned widgets are anchored to the screen edges.
        fit: StackFit.expand,
        children: [
          // Top Curved Background - remains responsive
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
                    'assets/images/food.png', // optional pattern image
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(), // Handles asset not found
                  ),
                ),
              ),
            ),
          ),
          // Bottom Curved Background - positioned to always stay at the bottom
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
                    'assets/images/food.png', // optional pattern image
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(), // Handles asset not found
                  ),
                ),
              ),
            ),
          ),
          // Main Content - now fully responsive and handles scrolling correctly
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06), // Responsive padding
              child: SingleChildScrollView(
                // Allows content to scroll
                // Added padding to the bottom to ensure content doesn't scroll under the fixed bottom curve
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
                      'Register',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04), // Responsive spacing
                    const CustomTextField(hint: 'Username'),
                    SizedBox(
                        height: screenHeight * 0.025), // Responsive spacing
                    const CustomTextField(hint: 'Password', obscureText: true),
                    SizedBox(
                        height: screenHeight * 0.025), // Responsive spacing
                    const CustomTextField(
                      hint: 'Confirm Password',
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.05), // Responsive spacing
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Example navigation. Ensure '/dashboard' route exists.
                          Navigator.pushNamed(context, '/dashboard');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5858),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.2, // Responsive padding
                            vertical:
                                screenHeight * 0.018, // Responsive padding
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                screenWidth * 0.03), // Responsive radius
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                screenWidth * 0.04, // Responsive font size
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

// Custom Text Field Widget - remains responsive
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
          borderRadius:
              BorderRadius.circular(screenWidth * 0.05), // Responsive radius
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(screenWidth * 0.05), // Responsive radius
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }
}

// Clippers remain the same as they operate on the size of their parent container
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

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

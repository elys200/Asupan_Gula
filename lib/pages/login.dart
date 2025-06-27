import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetsense/controllers/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _authController = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // TOP CURVED BACKGROUND
          ClipPath(
            clipper: CurvedTopClipper(),
            child: Container(
              height: screenHeight * 0.25,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE43A15), Color(0xFFE65245)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/food3.png',
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.07),
                    colorBlendMode: BlendMode.srcATop,
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM BACKGROUND IMAGE
          Positioned(
            bottom: 0,
            left: -5,
            right: 0,
            child: Image.asset(
              'assets/images/bottom_clip.png',
              fit: BoxFit.cover,
              height: screenHeight * 0.3,
            ),
          ),

          // MAIN CONTENT
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: InkWell(
                        onTap: () => Get.offAllNamed('/welcome'),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.chevron_left,
                              color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.17),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.035),
                  CustomTextField(
                    hint: 'Username',
                    controller: usernameController,
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  CustomTextField(
                    hint: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final username = usernameController.text.trim();
                        final password = passwordController.text.trim();

                        if (username.isEmpty || password.isEmpty) {
                          Get.snackbar(
                            'Login Gagal',
                            'Username dan password tidak boleh kosong',
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        final result = await _authController.login(
                          username: username,
                          password: password,
                        );

                        if (result != null) {
                          Get.offAllNamed('/dashboard');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5858),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.2,
                          vertical: screenHeight * 0.018,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text.rich(
                        TextSpan(
                          text: "Belum memiliki akun?",
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                          ),
                          children: [
                            TextSpan(
                              text: 'Daftar Sekarang',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontSize: screenWidth * 0.035,
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
        ],
      ),
    );
  }
}

// Reusable Text Field Widget
class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 45,
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hint,
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

// Lengkungan atas seperti register
class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final roundingHeight = size.height * 3 / 5;
    final filledRectangle =
        Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);
    final roundingRectangle = Rect.fromLTRB(
        -5, size.height - roundingHeight * 2, size.width + 5, size.height);

    final path = Path();
    path.addRect(filledRectangle);
    path.arcTo(roundingRectangle, pi, -pi, true);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

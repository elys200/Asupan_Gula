import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetsense/controllers/authentication.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _umurController = TextEditingController();
  final _beratBadanController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthenticationController>();

  String? _selectedGender;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _umurController.dispose();
    _beratBadanController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Lengkung Atas
          ClipPath(
            clipper: CurvedTopClipper(),
            child: Container(
              height: screenHeight * 0.20,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE43A15), Color(0xFFE65245)],
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

          // Background Bawah
          Positioned(
            bottom: 0,
            left: -20,
            right: 0,
            child: Image.asset(
              'assets/images/bottom_clip.png',
              fit: BoxFit.cover,
              height: screenHeight * 0.2,
            ),
          ),

          // Content utama
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.17),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                // Form area
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.19,
                      vertical: screenHeight * 0,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        _buildCompactTextField(
                            hint: 'Nama Pengguna',
                            controller: _usernameController),
                        SizedBox(height: screenHeight * 0.015),
                        _buildCompactTextField(
                            hint: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress),
                        SizedBox(height: screenHeight * 0.015),
                        _buildCompactTextField(
                            hint: 'Umur',
                            controller: _umurController,
                            keyboardType: TextInputType.number),
                        SizedBox(height: screenHeight * 0.015),
                        _buildCompactTextField(
                            hint: 'Berat Badan (kg)',
                            controller: _beratBadanController,
                            keyboardType: TextInputType.number),
                        SizedBox(height: screenHeight * 0.015),
                        _buildCompactGenderDropdown(),
                        SizedBox(height: screenHeight * 0.015),
                        _buildCompactTextField(
                            hint: 'Kata Sandi',
                            controller: _passwordController,
                            obscureText: true),
                        SizedBox(height: screenHeight * 0.015),
                        _buildCompactTextField(
                            hint: 'Konfirmasi Kata Sandi',
                            controller: _confirmPasswordController,
                            obscureText: true),
                        SizedBox(height: screenHeight * 0.03),
                        _buildRegisterButton(screenWidth, screenHeight),
                        SizedBox(height: screenHeight * 0.1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Kembali
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Material(
              color: Colors.transparent,
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
        ],
      ),
    );
  }

  // TextField yang lebih kompak
  Widget _buildCompactTextField({
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE43A15), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE43A15), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE43A15), width: 1.5),
          ),
        ),
      ),
    );
  }

  // Dropdown jenis kelamin
  Widget _buildCompactGenderDropdown() {
    return SizedBox(
      height: 45,
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        items: const [
          DropdownMenuItem(
              value: 'Pria',
              child: Text('Pria', style: TextStyle(fontSize: 14))),
          DropdownMenuItem(
              value: 'Wanita',
              child: Text('Wanita', style: TextStyle(fontSize: 14))),
        ],
        onChanged: (value) => setState(() => _selectedGender = value),
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Jenis Kelamin',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE43A15), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE43A15), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE43A15), width: 1.5),
          ),
        ),
      ),
    );
  }

  // Tombol register
  Widget _buildRegisterButton(double screenWidth, double screenHeight) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Obx(() {
        final isLoading = _authController.isLoading.value;

        return SizedBox(
          width: screenWidth * 0.3,
          height: screenHeight * 0.06,
          child: ElevatedButton(
            onPressed: isLoading ? null : _onRegisterPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5858),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              elevation: 5,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      }),
    );
  }

  Future<void> _onRegisterPressed() async {
    // Validasi dan panggil controller
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final umurStr = _umurController.text.trim();
    final beratStr = _beratBadanController.text.trim();
    final jenisKelamin = (_selectedGender ?? '').trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if ([
      username,
      email,
      umurStr,
      beratStr,
      jenisKelamin,
      password,
      confirmPassword
    ].contains('')) {
      Get.snackbar('Error', 'Harap lengkapi semua field!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final umur = int.tryParse(umurStr);
    final beratBadan = int.tryParse(beratStr);

    if (umur == null || beratBadan == null) {
      Get.snackbar('Error', 'Umur dan Berat Badan harus berupa angka!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Konfirmasi kata sandi tidak cocok!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final result = await _authController.register(
      username: username,
      email: email,
      umur: umur,
      beratBadan: beratBadan,
      jenisKelamin: jenisKelamin,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (result != null && result['user'] != null) {
      Get.snackbar('Success', 'Registrasi berhasil! Silakan login.',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAllNamed('/login');
    }
  }
}

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

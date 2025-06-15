import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetsense/controllers/authentication.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers untuk backend
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
    // Get screen dimensions untuk responsive layout
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Atas (Frontend Baru)
          _buildTopCurveBackground(screenHeight),

          // Background Bawah (Frontend Baru)
          _buildBottomCurveBackground(screenHeight),

          // Main Content dengan Backend Integration
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: screenHeight * 0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Title dengan responsive font
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Username Field
                    CustomTextField(
                      controller: _usernameController,
                      hint: 'Username',
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // Umur Field
                    CustomTextField(
                      controller: _umurController,
                      hint: 'Umur',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // Berat Badan Field
                    CustomTextField(
                      controller: _beratBadanController,
                      hint: 'Berat Badan (kg)',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // Gender Dropdown
                    _buildGenderDropdown(screenWidth),
                    SizedBox(height: screenHeight * 0.025),

                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      hint: 'Kata Sandi',
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // Confirm Password Field
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hint: 'Konfirmasi Kata Sandi',
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // Register Button dengan Backend Integration
                    _buildRegisterButton(screenWidth, screenHeight),
                  ],
                ),
              ),
            ),
          ),

          // Tombol Kembali (Frontend Baru)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.offAllNamed('/welcome'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCurveBackground(double screenHeight) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipPath(
        clipper: TopCurveClipper(),
        child: Container(
          height: screenHeight * 0.15, // Responsive height
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
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCurveBackground(double screenHeight) {
    return Positioned(
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
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(double screenWidth) {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: const [
        DropdownMenuItem(value: 'Pria', child: Text('Pria')),
        DropdownMenuItem(value: 'Wanita', child: Text('Wanita')),
      ],
      onChanged: (value) => setState(() => _selectedGender = value),
      decoration: InputDecoration(
        hintText: 'Jenis Kelamin',
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(double screenWidth, double screenHeight) {
    return Center(
      child: SizedBox(
        width: screenWidth * 0.5, // Responsive width
        height: screenHeight * 0.06, // Responsive height
        child: Obx(() {
          return _authController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5858)),
                  ),
                )
              : ElevatedButton(
                  onPressed: _onRegisterPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5858),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
        }),
      ),
    );
  }

  // Backend Logic - Tetap dipertahankan
  Future<void> _onRegisterPressed() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final umurStr = _umurController.text.trim();
    final beratStr = _beratBadanController.text.trim();
    final jenisKelamin = (_selectedGender ?? '').trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validasi field kosong
    if ([
      username,
      email,
      umurStr,
      beratStr,
      jenisKelamin,
      password,
      confirmPassword
    ].contains('')) {
      Get.snackbar(
        'Error',
        'Harap lengkapi semua field!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi numeric fields
    final umur = int.tryParse(umurStr);
    final beratBadan = int.tryParse(beratStr);

    if (umur == null || beratBadan == null) {
      Get.snackbar(
        'Error',
        'Umur dan Berat Badan harus berupa angka!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi password match
    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Konfirmasi kata sandi tidak cocok!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Call backend register method
    final result = await _authController.register(
      username: username,
      email: email,
      umur: umur,
      beratBadan: beratBadan,
      jenisKelamin: jenisKelamin,
      password: password,
      confirmPassword: confirmPassword,
    );

    // Handle result
    if (result != null && result['user'] != null) {
      Get.snackbar(
        'Success',
        'Registrasi berhasil! Silakan login.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/login');
    }
  }
}

// Custom Text Field Widget - Responsive dengan Backend Integration
class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hint,
    this.obscureText = false,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          borderSide: const BorderSide(color: Color(0xFFFF5858), width: 2),
        ),
      ),
    );
  }
}

// Clippers tetap sama
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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
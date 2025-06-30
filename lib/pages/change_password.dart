// Nama File: change_password.dart
// Deskripsi: Halaman untuk mengubah password pengguna
// Dibuat oleh: Jihan Safinatunnaja - NIM: 3312301065
// Tanggal: 6 May 2024

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sweetsense/controllers/profile_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Kata Sandi Baru',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: ListView(
          children: [
            // Header Section
            _buildHeaderSection(),

            // Input Section
            _buildPasswordInputFields(),

            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Membangun header halaman
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ganti Kata Sandi',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mohon masukkan kata sandi baru',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Membangun form input password
  Widget _buildPasswordInputFields() {
    return Column(
      children: [
        TextFormField(
          controller: _currentPasswordController,
          obscureText: _obscureCurrentPassword,
          decoration: InputDecoration(
            labelText: 'Kata Sandi Lama',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureCurrentPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () => setState(() {
                _obscureCurrentPassword = !_obscureCurrentPassword;
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          decoration: InputDecoration(
            labelText: 'Kata Sandi Baru',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () => setState(() {
                _obscureNewPassword = !_obscureNewPassword;
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Konfirmasi Kata Sandi',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () => setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              }),
            ),
          ),
        ),
      ],
    );
  }

  // Membangun tombol submit
  Widget _buildSubmitButton() {
    final controller = Get.find<ProfileController>();
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Center(
        child: Obx(() => SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isChangingPassword.value
                    ? null
                    : _handlePasswordChange,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4A4A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: const Color.fromRGBO(255, 74, 74, 0.5),
                ),
                child: controller.isChangingPassword.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Simpan',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            )),
      ),
    );
  }

  // Handler untuk tombol ganti password
  void _handlePasswordChange() async {
    final current = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (newPassword != confirm) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Konfirmasi kata sandi tidak cocok.',
        confirmBtnText: 'OK',
        backgroundColor: Colors.white,
        confirmBtnColor: const Color(0xFFFF4A4A),
        confirmBtnTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        borderRadius: 20,
      );
      return;
    }

    final controller = Get.find<ProfileController>();
    final result =
        await controller.changePassword(current, newPassword, confirm);

    if (!mounted) return;

    final bool isSuccess = result['success'] ?? false;
    final String message = result['message'] ?? 'Terjadi kesalahan.';

    QuickAlert.show(
      context: context,
      type: isSuccess ? QuickAlertType.success : QuickAlertType.error,
      text: message,
      confirmBtnText: 'OK',
      backgroundColor: Colors.white,
      confirmBtnColor: const Color(0xFFFF4A4A),
      confirmBtnTextStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      borderRadius: 20,
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        if (isSuccess) Navigator.of(context).pop();
      },
    );
  }
}

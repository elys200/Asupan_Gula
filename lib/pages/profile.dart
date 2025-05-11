// Nama File: profile.dart
// Deskripsi: Halaman profil pengguna yang menampilkan informasi pengguna, opsi pengeditan profil, dan logout.
// Dibuat oleh: Jihan Safinatunnaja - NIM: 3312301065
// Tanggal: 6 May 2024

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile; // Menyimpan gambar profil yang dipilih dari galeri
  final ImagePicker _picker =
      ImagePicker(); // Untuk memilih gambar dari perangkat

  /// Memilih gambar dari galeri pengguna dan memperbarui state.
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Gagal memilih gambar: $e');
    }
  }

  /// Menampilkan dialog konfirmasi logout menggunakan QuickAlert.
  void _showExitQuickAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Logout Akun',
      text: 'Anda yakin ingin keluar dari akun anda?',
      showCancelBtn: true,
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.red.shade800,
      onConfirmBtnTap: () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/welcome', (route) => false);
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 16),
              _buildMenuList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Membuat AppBar dengan judul "Profile" dan tombol kembali.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Profile',
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, '/dashboard'),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE43A15), Color(0xFFE65245)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      elevation: 0,
    );
  }

  /// Membuat header profil dengan foto, nama, dan email.
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE43A15), Color(0xFFE65245)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51), // 0.2 * 255 ≈ 51
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            // Stack untuk menempatkan foto profil dan tombol kamera
            Stack(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage('assets/images/portrait.png')
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Elys',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'elys132@gmail.com',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  /// Membuat daftar menu profil (Edit Profile, Ganti Password, dll).
  Widget _buildMenuList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () => Navigator.pushNamed(context, '/edit_profile'),
          ),
          const SizedBox(height: 20),
          _buildMenuItem(
            icon: Icons.lock,
            title: 'Ganti Kata Sandi',
            onTap: () => Navigator.pushNamed(context, '/change_password'),
          ),
          const SizedBox(height: 20),
          _buildMenuItem(
            icon: Icons.favorite,
            title: 'Resep Favorit',
            onTap: () => Navigator.pushNamed(context, '/favorite_recipe'),
          ),
          const SizedBox(height: 20),
          _buildMenuItem(
            icon: Icons.exit_to_app,
            title: 'Logout',
            onTap: _showExitQuickAlert,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Membuat item menu individual dengan ikon dan judul.
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            // Container untuk ikon dengan latar belakang bulat
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE43A15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

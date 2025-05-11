// Nama File: edit_profile.dart
// Deskripsi: Halaman untuk mengedit profil pengguna.
// Dibuat oleh: Jihan Safinatunnaja - NIM: 3312301065
// Tanggal: 6 May 2024

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

/// Halaman untuk mengedit profil pengguna.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _hasChanged = false;

  // Controller untuk form field dengan nilai default
  late final TextEditingController _nameController;
  late final TextEditingController _birthController;
  late final TextEditingController _genderController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai awal
    _nameController = TextEditingController(text: 'Elys');
    _birthController = TextEditingController(text: '01/01/2000');
    _genderController = TextEditingController(text: 'Perempuan');
    _weightController = TextEditingController(text: '55');

    // Untuk mendeteksi perubahan pada text field
    _nameController.addListener(_onTextChanged);
    _birthController.addListener(_onTextChanged);
    _genderController.addListener(_onTextChanged);
    _weightController.addListener(_onTextChanged);
  }

  // Callback yang dijalankan ketika ada perubahan pada text field
  void _onTextChanged() {
    if (!_hasChanged) {
      setState(() => _hasChanged = true);
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _birthController.removeListener(_onTextChanged);
    _genderController.removeListener(_onTextChanged);
    _weightController.removeListener(_onTextChanged);

    _nameController.dispose();
    _birthController.dispose();
    _genderController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 16),
                  _buildEditableField(_nameController, 'Nama Pengguna'),
                  _buildEditableField(_birthController, 'Tanggal Lahir'),
                  _buildEditableField(_genderController, 'Gender'),
                  _buildEditableField(
                    _weightController,
                    'Berat Badan (kg)',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 5),
                  _buildSaveButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Edit Profile',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE43A15), Color(0xFFE65245)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            _buildProfileImageWithButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageWithButton() {
    return Stack(
      children: [
        _buildProfileImage(),
        Positioned(
          bottom: 0,
          right: 4,
          child: GestureDetector(
            onTap: _pickImage,
            child: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(Icons.camera_alt, size: 16, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 45,
      backgroundColor: Colors.white,
      // Menggunakan image file jika ada,kembali ke asset default
      backgroundImage:
          _imageFile != null
              ? FileImage(_imageFile!)
              : const AssetImage('assets/images/portrait.png') as ImageProvider,
    );
  }

  Widget _buildEditableField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
          floatingLabelStyle: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.black,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE43A15), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        onPressed: _hasChanged ? _saveChanges : null,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(180, 48),
          backgroundColor:
              _hasChanged ? const Color(0xFFFF4A4A) : Colors.grey.shade300,
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Simpan Perubahan',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    setState(() => _hasChanged = false);

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Perubahan berhasil disimpan!',
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
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _hasChanged = true;
        });
      }
    } catch (e) {
      debugPrint('Gagal memilih gambar: \$e');
    }
  }
}

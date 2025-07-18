import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/profile_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileController profileController = Get.find<ProfileController>();

  File? _imageFile;
  bool _hasChanged = false;
  bool _isUploadingImage = false;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _birthController;
  late String _genderValue;
  late final TextEditingController _weightController;

  final List<String> _genderOptions = ['Pria', 'Wanita'];

  @override
  void initState() {
    super.initState();

    final user = profileController.user.value;

    _nameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _birthController =
        TextEditingController(text: (user?.umur ?? 0).toString());
    _genderValue = user?.jenisKelamin ?? 'Pria';
    _weightController =
        TextEditingController(text: (user?.beratBadan ?? 0.0).toString());

    _nameController.addListener(_onTextChanged);
    _emailController.addListener(_onTextChanged);
    _birthController.addListener(_onTextChanged);
    _weightController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_hasChanged) {
      setState(() => _hasChanged = true);
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _emailController.removeListener(_onTextChanged);
    _birthController.removeListener(_onTextChanged);
    _weightController.removeListener(_onTextChanged);

    _nameController.dispose();
    _emailController.dispose();
    _birthController.dispose();
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
                  _buildEditableField(_nameController, 'Nama Pengguna',
                      noSpaces: true),
                  _buildEditableField(_emailController, 'Email',
                      keyboardType: TextInputType.emailAddress, noSpaces: true),
                  _buildEditableField(_birthController, 'Umur',
                      keyboardType: TextInputType.number),
                  _buildGenderDropdown(),
                  _buildEditableField(_weightController, 'Berat Badan (kg)',
                      keyboardType: TextInputType.number),
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
            Stack(
              children: [
                _buildProfileImage(),
                if (_isUploadingImage)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final user = profileController.user.value;

    if (_imageFile != null) {
      return CircleAvatar(
        radius: 45,
        backgroundColor: Colors.white,
        backgroundImage: FileImage(_imageFile!),
      );
    } else if (user?.fotoUrl != null && user!.fotoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: user.fotoUrl!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 45,
          backgroundColor: Colors.white,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => _buildAvatarPlaceholder(),
        errorWidget: (context, url, error) => _buildAvatarPlaceholder(),
        memCacheHeight: 200,
        memCacheWidth: 200,
      );
    }
    return _buildAvatarPlaceholder();
  }

  Widget _buildAvatarPlaceholder() {
    return CircleAvatar(
      radius: 45,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }

  Widget _buildEditableField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool noSpaces = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters:
            noSpaces ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))] : null,
        style: GoogleFonts.poppins(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
          floatingLabelStyle:
              GoogleFonts.poppins(fontSize: 15, color: Colors.black),
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

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Jenis Kelamin',
          labelStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE43A15), width: 2),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _genderValue,
            isExpanded: true,
            items: _genderOptions
                .map((gender) => DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender,
                          style: GoogleFonts.poppins(fontSize: 15)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _genderValue = value;
                  _hasChanged = true;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: _hasChanged && !profileController.isUpdatingProfile.value
                ? _saveChanges
                : null,
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(180, 48),
              backgroundColor:
                  _hasChanged && !profileController.isUpdatingProfile.value
                      ? const Color(0xFFFF4A4A)
                      : Colors.grey.shade300,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: profileController.isUpdatingProfile.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Simpan Perubahan',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ));
  }

  Future<void> _saveChanges() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String birthStr = _birthController.text.trim();
    final String weightStr = _weightController.text.trim();

    // Validasi awal
    if (name.contains(' ') || email.contains(' ')) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Input Tidak Valid',
        text: 'Nama pengguna dan email tidak boleh mengandung spasi.',
        confirmBtnText: 'OK',
        confirmBtnColor: const Color(0xFFFF4A4A),
      );
      return;
    }

    if (name.isEmpty || email.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Input Tidak Valid',
        text: 'Nama pengguna dan email tidak boleh kosong.',
        confirmBtnText: 'OK',
        confirmBtnColor: const Color(0xFFFF4A4A),
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Input Tidak Valid',
        text: 'Format email tidak valid.',
        confirmBtnText: 'OK',
        confirmBtnColor: const Color(0xFFFF4A4A),
      );
      return;
    }

    int? umur = int.tryParse(birthStr);
    double? berat = double.tryParse(weightStr);

    if (umur == null ||
        berat == null ||
        umur <= 0 ||
        umur > 150 ||
        berat <= 0 ||
        berat > 500) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Input Tidak Valid',
        text: 'Umur harus 1-150 tahun dan berat 1-500 kg.',
        confirmBtnText: 'OK',
        confirmBtnColor: const Color(0xFFFF4A4A),
      );
      return;
    }

    final current = profileController.user.value;
    if (current != null &&
        name == current.username &&
        email == current.email &&
        umur == current.umur &&
        berat == current.beratBadan &&
        _genderValue == current.jenisKelamin &&
        _imageFile == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Tidak Ada Perubahan',
        text: 'Silakan ubah data terlebih dahulu.',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.blue,
      );
      return;
    }

    profileController.isUpdatingProfile.value = true;

    final success = await profileController.updateProfile(
      username: name,
      email: email,
      jenisKelamin: _genderValue,
      umur: umur,
      beratBadan: berat,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _hasChanged = false;
      });
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Perubahan berhasil disimpan!',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.green,
        confirmBtnTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        borderRadius: 20,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Gagal',
        text: 'Gagal menyimpan perubahan. Coba lagi nanti.',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.red,
      );
    }
    profileController.isUpdatingProfile.value = false;
  }
}

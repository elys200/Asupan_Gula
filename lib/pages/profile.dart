import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/authentication.dart';
import '../../controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final AuthenticationController _authController =
      Get.find<AuthenticationController>();
  final ProfileController _controller = Get.put(ProfileController());
  final ImagePicker _picker = ImagePicker();

  bool _isUploadingImage = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.fetchProfile();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 80);
      if (pickedFile != null) {
        setState(() => _isUploadingImage = true);
        final file = File(pickedFile.path);
        await _controller.setProfileImage(file);
      }
    } catch (e) {
      debugPrint('Gagal memilih gambar: $e');
      Get.snackbar('Error', 'Gagal memilih gambar.\n$e');
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

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
      onConfirmBtnTap: () async {
        Get.back();
        try {
          await _authController.logout();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/welcome', (route) => false);
        } catch (e) {
          Get.snackbar('Logout gagal', 'Terjadi kesalahan saat logout.\n$e');
        }
      },
      onCancelBtnTap: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() => Column(
                children: [
                  _buildProfileHeader(),
                  if (_isUploadingImage)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: CircularProgressIndicator(),
                    ),
                  const SizedBox(height: 16),
                  _buildMenuList(),
                ],
              )),
        ),
      ),
    );
  }

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

  Widget _buildProfileHeader() {
    final user = _controller.user.value;
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
            color: Colors.black.withAlpha(51),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                Obx(() {
                  if (_controller.imageFile.value != null) {
                    return CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage: FileImage(_controller.imageFile.value!),
                    );
                  } else if (user?.fotoUrl != null &&
                      user!.fotoUrl!.isNotEmpty) {
                    return CachedNetworkImage(
                      imageUrl: user.fotoUrl!,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => _buildAvatarPlaceholder(),
                      errorWidget: (context, url, error) =>
                          _buildAvatarPlaceholder(),
                      memCacheHeight: 200,
                      memCacheWidth: 200,
                    );
                  }
                  return _buildAvatarPlaceholder();
                }),
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
              user?.username ?? 'Loading...',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return CircleAvatar(
      radius: 45,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }

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

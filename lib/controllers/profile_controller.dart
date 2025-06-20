import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dioLib;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import '../models/user_model.dart';
import '../constants/constants.dart';
import 'authentication.dart';
import 'package:mime/mime.dart';

class ProfileController extends GetxController {
  final AuthenticationController _auth = Get.find<AuthenticationController>();
  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final imageFile = Rxn<File>();

  final dio = dioLib.Dio(
    dioLib.BaseOptions(
      baseUrl: url,
      headers: {'Accept': 'application/json'},
    ),
  );

  /// Mengambil data profil user
  Future<void> fetchProfile() async {
    final token = _auth.token.value;
    if (token == null) {
      Get.snackbar('Error', 'Silakan login terlebih dahulu.');
      return;
    }

    isLoading.value = true;
    try {
      final res = await dio.get(
        'user/profile',
        options: dioLib.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (res.statusCode == 200) {
        user.value = UserModel.fromJson(res.data);
      } else {
        Get.snackbar('Error', 'Gagal mengambil data profil');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan koneksi.\n$e');
    } finally {
      isLoading.value = false;
    }
  }

  // Menyimpan file gambar lokal
  Future<void> setProfileImage(File file) async {
    imageFile.value = file;
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      await updateProfilePhoto(
        fotoBytes: bytes,
        filename: file.path.split('/').last,
      );
    } else {
      await updateProfilePhoto(fotoFile: file);
    }
  }

  // Update data profil user
  Future<void> updateProfile({
    String? username,
    String? email,
    String? jenisKelamin,
    int? umur,
    double? beratBadan, File? imageFile,
  }) async {
    final token = _auth.token.value;
    if (token == null) {
      throw Exception('Silakan login terlebih dahulu.');
    }

    try {
      final formData = dioLib.FormData.fromMap({
        '_method': 'PUT',
        if (username != null) 'username': username,
        if (email != null) 'email': email,
        if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
        if (umur != null) 'umur': umur.toString(),
        if (beratBadan != null) 'berat_badan': beratBadan.toString(),
      });

      final res = await dio.post(
        'user/profile',
        data: formData,
        options: dioLib.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      user.value = UserModel.fromJson(res.data['user']);
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil.\n${e.toString()}');
    }
  }

  // Update foto profil user
  Future<void> updateProfilePhoto({
    File? fotoFile,
    Uint8List? fotoBytes,
    String? filename,
  }) async {
    final token = _auth.token.value;
    if (token == null) {
      Get.snackbar('Error', 'Silakan login terlebih dahulu.');
      return;
    }

    try {
      dioLib.MultipartFile? multipartFile;

      if (fotoFile != null) {
        final mimeType = lookupMimeType(fotoFile.path) ?? 'image/jpeg';
        final mimeSplit = mimeType.split('/');

        multipartFile = await dioLib.MultipartFile.fromFile(
          fotoFile.path,
          filename: fotoFile.path.split('/').last,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        );
      }

      else if (fotoBytes != null && filename != null) {
        final mimeType = lookupMimeType(filename) ?? 'image/jpeg';
        final mimeSplit = mimeType.split('/');

        multipartFile = dioLib.MultipartFile.fromBytes(
          fotoBytes,
          filename: filename,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        );
      } else {
        Get.snackbar('Error', 'File foto tidak valid.');
        return;
      }

      final formData = dioLib.FormData.fromMap({'foto': multipartFile});

      final res = await dio.post(
        'user/profile/foto',
        data: formData,
        options: dioLib.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        user.value = UserModel.fromJson(res.data['user']);
        imageFile.value = null;
        Get.snackbar('Berhasil', 'Foto profil berhasil diperbarui');
      } else {
        Get.snackbar('Error', 'Gagal memperbarui foto.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui foto.\n${e.toString()}');
    }
  }

  // Update kata sandi user
  Future<void> changePassword(
      String current, String newPassword, String confirm) async {
    final token = _auth.token.value;
    if (token == null) {
      Get.snackbar('Error', 'Silakan login terlebih dahulu.');
      return;
    }

    try {
      final res = await dio.post(
        'user/profile/change-password',
        data: {
          'current_password': current,
          'new_password': newPassword,
          'new_password_confirmation': confirm,
        },
        options: dioLib.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200) {
        Get.snackbar('Sukses', 'Kata sandi berhasil diubah');
      } else {
        Get.snackbar('Gagal', res.data['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghubungi server.\n$e');
    }
  }

  void refreshProfile() {}
}

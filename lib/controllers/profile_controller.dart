import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dioLib;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:quickalert/quickalert.dart';
import 'package:mime/mime.dart';

import '../models/user_model.dart';
import '../constants/constants.dart';
import 'authentication.dart';

class ProfileController extends GetxController {
  final AuthenticationController _auth = Get.find();
  final dio = dioLib.Dio(dioLib.BaseOptions(
    baseUrl: url,
    headers: {'Accept': 'application/json'},
  ));

  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isUpdatingProfile = false.obs;
  final isChangingPassword = false.obs;
  final imageFile = Rxn<File>();

  // --- PROFILE FETCHING ---

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
        options: dioLib.Options(headers: {'Authorization': 'Bearer $token'}),
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

  // --- PROFILE IMAGE HANDLING ---

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

  Future<void> updateProfilePhoto({
    File? fotoFile,
    Uint8List? fotoBytes,
    String? filename,
  }) async {
    final token = _auth.token.value;
    if (token == null) {
      _showLoginError();
      return;
    }

    try {
      final multipartFile = await _createMultipartFile(
        fotoFile: fotoFile,
        fotoBytes: fotoBytes,
        filename: filename,
      );

      if (multipartFile == null) {
        _showInvalidPhotoError();
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

        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.success,
          title: 'Berhasil',
          text: 'Foto profil berhasil diperbarui',
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
        );
      } else {
        _showPhotoUpdateError();
      }
    } catch (e) {
      _showPhotoUpdateError(message: e.toString());
    }
  }

  Future<dioLib.MultipartFile?> _createMultipartFile({
    File? fotoFile,
    Uint8List? fotoBytes,
    String? filename,
  }) async {
    try {
      if (fotoFile != null) {
        final mime =
            lookupMimeType(fotoFile.path)?.split('/') ?? ['image', 'jpeg'];
        return await dioLib.MultipartFile.fromFile(
          fotoFile.path,
          filename: fotoFile.path.split('/').last,
          contentType: MediaType(mime[0], mime[1]),
        );
      } else if (fotoBytes != null && filename != null) {
        final mime = lookupMimeType(filename)?.split('/') ?? ['image', 'jpeg'];
        return dioLib.MultipartFile.fromBytes(
          fotoBytes,
          filename: filename,
          contentType: MediaType(mime[0], mime[1]),
        );
      }
    } catch (_) {}
    return null;
  }

  Future<void> removeProfileImage() async {
    final token = _auth.token.value;
    if (token == null) {
      _showLoginError();
      return;
    }

    try {
      final res = await dio.delete(
        'user/profile/foto',
        options: dioLib.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200) {
        user.value = user.value?.copyWith(foto: null);
        imageFile.value = null;

        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.success,
          title: 'Berhasil',
          text: 'Foto profil berhasil dihapus',
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
        );
      } else {
        _showPhotoDeleteError();
      }
    } catch (e) {
      _showPhotoDeleteError(message: e.toString());
    }
  }

  // --- PROFILE DATA UPDATE ---

  Future<bool> updateProfile({
    String? username,
    String? email,
    String? jenisKelamin,
    int? umur,
    double? beratBadan,
  }) async {
    final token = _auth.token.value;
    if (token == null) {
      debugPrint('❌ Token null, user belum login?');
      return false;
    }

    isUpdatingProfile.value = true;

    try {
      debugPrint('🔧 Memulai updateProfile...');
      debugPrint('Data yang akan dikirim:');
      debugPrint('username: $username');
      debugPrint('email: $email');
      debugPrint('jenisKelamin: $jenisKelamin');
      debugPrint('umur: $umur');
      debugPrint('beratBadan: $beratBadan');

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
        options: dioLib.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('✅ Response diterima: ${res.statusCode}');
      debugPrint('📦 Data response: ${res.data}');

      // Simpan data user baru
      user.value = UserModel.fromJson(res.data['user']);
      return true;
    } catch (e) {
      debugPrint('❌ Terjadi error saat updateProfile: $e');

      if (e is dioLib.DioError) {
        debugPrint('📄 Status code: ${e.response?.statusCode}');
        debugPrint('📡 Response error: ${e.response?.data}');
      }

      return false;
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  // --- PASSWORD CHANGE ---

  Future<Map<String, dynamic>> changePassword(
    String current,
    String newPassword,
    String confirm,
  ) async {
    final token = _auth.token.value;
    if (token == null) {
      return {'success': false, 'message': 'Silakan login terlebih dahulu.'};
    }

    isChangingPassword.value = true;

    try {
      final response = await dio.post(
        'user/profile/change-password',
        data: {
          'current_password': current,
          'new_password': newPassword,
          'new_password_confirmation': confirm,
        },
        options: dioLib.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Kata sandi berhasil diubah.'
        };
      }
      return {'success': false, 'message': 'Gagal mengubah kata sandi.'};
    } on dioLib.DioError catch (e) {
      final data = e.response?.data;
      final errors = data?['errors'] ?? {};
      final firstError = errors.values.first;
      final message =
          firstError is List ? firstError.first : firstError.toString();
      return {'success': false, 'message': message ?? data?['message']};
    } catch (e) {
      return {'success': false, 'message': 'Kesalahan tak terduga: $e'};
    } finally {
      isChangingPassword.value = false;
    }
  }

  // --- UTILITIES ---

  void refreshProfile() {}

  void _showLoginError() {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Silakan login terlebih dahulu.',
      confirmBtnText: 'OK',
    );
  }

  void _showInvalidPhotoError() {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'File foto tidak valid.',
      confirmBtnText: 'OK',
    );
  }

  void _showPhotoUpdateError({String? message}) {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.error,
      title: 'Error',
      text: message ?? 'Gagal memperbarui foto.',
      confirmBtnText: 'OK',
    );
  }

  void _showPhotoDeleteError({String? message}) {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.error,
      title: 'Error',
      text: message ?? 'Gagal menghapus foto profil.',
      confirmBtnText: 'OK',
      confirmBtnColor: Colors.red,
    );
  }
}

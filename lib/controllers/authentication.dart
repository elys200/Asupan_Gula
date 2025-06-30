import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final RxnString token = RxnString();

  void _showFirstError(Map<String, dynamic> data) {
    if (data['errors'] != null && data['errors'] is Map) {
      final firstError = (data['errors'] as Map).values.first;
      if (firstError is List && firstError.isNotEmpty) {
        Get.snackbar(
          'Error',
          firstError.first.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else if (data['message'] != null) {
      Get.snackbar(
        'Error',
        data['message'].toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.error, color: Colors.white),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  @override
  void onInit() {
    super.onInit();
    _restoreToken();
  }

  Future<void> _restoreToken() async {
    final prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token');
  }

  Future<void> _persistToken(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove('token');
    } else {
      await prefs.setString('token', value);
    }
    token.value = value;
  }

  // Register
  Future<dynamic> register({
    required String username,
    required String email,
    required int umur,
    required int beratBadan,
    required String jenisKelamin,
    required String password,
    required String confirmPassword,
  }) async {
    isLoading.value = true;
    try {
      final uri = Uri.parse('${url}register');
      final response = await http
          .post(uri,
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'username': username,
                'email': email,
                'umur': umur.toString(),
                'berat_badan': beratBadan.toString(),
                'jenis_kelamin': jenisKelamin,
                'password': password,
                'password_confirmation': confirmPassword,
              }))
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 && data['user'] != null) {
        showSuccess('Sukses', 'Registrasi berhasil! Silakan login.');
        return data;
      }
      _showFirstError(data);
      return null;
    } catch (_) {
      showError('Error', 'Terjadi kesalahan. Coba lagi nanti.');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Login
  Future<dynamic> login({
    required String username,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final uri = Uri.parse('${url}login');
      final response = await http.post(uri,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'username': username, 'password': password}));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['user'] != null) {
        await _persistToken(data['token']);
        showSuccess('Sukses', 'Login berhasil!');
        return data;
      }
      _showFirstError(data);
      return null;
    } catch (_) {
      showError('Error', 'Terjadi kesalahan. Coba lagi nanti.');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');

      if (authToken == null) {
        showError('Error', 'Token tidak ditemukan.');
        return;
      }

      final uri = Uri.parse('${url}logout');
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _persistToken(null);
        showSuccess('Sukses', data['message'] ?? 'Logout berhasil.');
        Get.offAllNamed('/login');
      } else {
        _showFirstError(data);
      }
    } catch (_) {
      showError('Error', 'Gagal logout. Periksa koneksi Anda.');
    } finally {
      isLoading.value = false;
    }
  }
}

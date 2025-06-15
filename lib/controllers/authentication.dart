import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;

  final RxnString token = RxnString();

  void _showFirstError(Map<String, dynamic> data) {
    if (data['errors'] != null && data['errors'] is Map) {
      final firstError = (data['errors'] as Map).values.first;
      if (firstError is List && firstError.isNotEmpty) {
        Get.snackbar('Error', firstError.first.toString());
      }
    } else if (data['message'] != null) {
      Get.snackbar('Error', data['message'].toString());
    }
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
        Get.snackbar('Sukses', 'Registrasi berhasil! Silakan login.');
        return data;
      }
      _showFirstError(data);
      return null;
    } catch (_) {
      Get.snackbar('Error', 'Terjadi kesalahan. Coba lagi nanti.');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  //Login
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
        Get.snackbar('Sukses', 'Login berhasil!');
        return data;
      }
      _showFirstError(data);
      return null;
    } catch (_) {
      Get.snackbar('Error', 'Terjadi kesalahan. Coba lagi nanti.');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  //Logout
  Future<void> logout() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');

      if (authToken == null) {
        Get.snackbar('Error', 'Token tidak ditemukan.');
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
        await _persistToken(null); // hapus token dari penyimpanan lokal
        Get.snackbar('Sukses', data['message'] ?? 'Logout berhasil.');
        Get.offAllNamed('/login'); // redirect ke halaman login
      } else {
        _showFirstError(data);
      }
    } catch (_) {
      Get.snackbar('Error', 'Gagal logout. Periksa koneksi Anda.');
    } finally {
      isLoading.value = false;
    }
  }
}

import '../models/jurnal_entry.dart';
import '../services/jurnal_service.dart';
import 'package:get/get.dart';

class JurnalController extends GetxController {
  final JurnalApiService apiService;

  RxList<JurnalEntry> jurnalList = <JurnalEntry>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  int? userId;

  JurnalController(this.apiService);

  void setUserId(int id) {
    userId = id;
  }

  Future<void> fetchJurnal() async {
    if (userId == null) {
      error.value = 'User ID belum diatur';
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      final list = await apiService.fetchJurnal(userId!);
      jurnalList.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> tambahJurnal(JurnalEntry entry) async {
    if (userId == null) {
      error.value = 'User ID belum diatur';
      return;
    }

    try {
      await apiService.tambahJurnal(entry, userId!);
      await fetchJurnal(); // refresh
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> hapusJurnal(int id) async {
    if (userId == null) {
      error.value = 'User ID belum diatur';
      return;
    }

    try {
      await apiService.hapusJurnal(id);
      await fetchJurnal(); // refresh
    } catch (e) {
      error.value = e.toString();
    }
  }
}

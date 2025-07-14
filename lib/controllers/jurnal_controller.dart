import '../models/jurnal_entry.dart';
import '../services/jurnal_service.dart';
import 'package:get/get.dart';

// Controller untuk mengelola data jurnal makan
class JurnalController extends GetxController {
  final JurnalApiService apiService;

  // list data jurnal
  final RxList<JurnalEntry> jurnalList = <JurnalEntry>[].obs;

  // Status loading & error
  final RxBool isLoading = false.obs;
  final RxBool isFetchingMore = false.obs;
  final RxString error = ''.obs;

  // Pagination
  final RxBool hasMore = true.obs;
  int currentPage = 1;
  final int perPage = 10;

  int? userId;

  // Total seluruh jurnal
  final RxInt totalEntries = 0.obs;

  JurnalController(this.apiService);

  // Set user ID & token untuk API
  void setUserId(int id) => userId = id;
  void setToken(String token) => apiService.token = token;

  // Ambil data jurnal (bisa refresh)
  Future<void> fetchJurnal({bool refresh = false}) async {
    if (userId == null) {
      error.value = 'User ID belum diatur';
      return;
    }

    if (!hasMore.value && !refresh) return;

    if (refresh) {
      currentPage = 1;
      hasMore.value = true;
      jurnalList.clear();
    }

    isLoading.value = true;
    error.value = '';

    try {
      final result = await apiService.fetchJurnal(
        userId!,
        page: currentPage,
        perPage: perPage,
      );

      if (refresh) {
        jurnalList.assignAll(result.entries);
      } else {
        jurnalList.addAll(result.entries);
      }

      totalEntries.value = result.total;
      hasMore.value = currentPage < result.lastPage;

      if (hasMore.value) currentPage++;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Ambil halaman berikutnya
  Future<void> loadMore() async {
    if (isLoading.value || isFetchingMore.value || !hasMore.value) return;

    isFetchingMore.value = true;
    error.value = '';

    try {
      final result = await apiService.fetchJurnal(
        userId!,
        page: currentPage,
        perPage: perPage,
      );

      jurnalList.addAll(result.entries);
      totalEntries.value = result.total;
      hasMore.value = currentPage < result.lastPage;

      if (hasMore.value) currentPage++;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isFetchingMore.value = false;
    }
  }

  // Tambah jurnal baru lalu refresh
  Future<void> tambahJurnal(JurnalEntry entry) async {
    if (userId == null) {
      error.value = 'User ID belum diatur';
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      await apiService.tambahJurnal(entry, userId!);
      await fetchJurnal(refresh: true);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Reset semua state
  void reset() {
    jurnalList.clear();
    isLoading.value = false;
    isFetchingMore.value = false;
    error.value = '';
    hasMore.value = true;
    currentPage = 1;
    totalEntries.value = 0;
    userId = null;
  }
}

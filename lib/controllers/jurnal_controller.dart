import 'package:get/get.dart';
import '../models/jurnal_entry.dart';
import '../services/jurnal_service.dart';
// TAMBAHAN: Pastikan path ini benar untuk mengimpor enum SugarStatus
import 'package:sweetsense/pages/dashboard.dart';

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

  // --- TAMBAHAN: State untuk Dashboard ---
  final RxDouble totalGulaHariIni = 0.0.obs;
  final Rx<SugarStatus> statusGulaHariIni = SugarStatus.none.obs;
  // --- Akhir Tambahan ---

  JurnalController(this.apiService);

  // --- TAMBAHAN: Fungsi baru untuk kalkulasi ---
  void _hitungDanSetStatusGulaHarian() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Filter jurnal hanya untuk hari ini
    // Asumsi: model JurnalEntry Anda punya 'DateTime tanggal'
    final jurnalHariIni = jurnalList.where((entry) {
  // 1. Ubah String tanggal dari API menjadi objek DateTime
  final parsedDate = DateTime.parse(entry.tanggal); 
  // 2. Hilangkan informasi jam, menit, detik untuk perbandingan
  final entryDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
  return entryDate.isAtSameMomentAs(today);
}).toList();

    // Hitung total gula dari jurnal hari ini
    // Asumsi: model JurnalEntry Anda punya 'double? gula'
    double totalGula = jurnalHariIni.fold(0.0, (sum, entry) => sum + (entry.totalGula));

    // Update state total gula
    totalGulaHariIni.value = totalGula;

    // Tentukan status berdasarkan batasan (silakan sesuaikan batasan ini)
    if (jurnalHariIni.isEmpty) {
      statusGulaHariIni.value = SugarStatus.none;
    } else if (totalGula <= 25) {
      // Contoh: di bawah 25g = Low
      statusGulaHariIni.value = SugarStatus.low;
    } else if (totalGula <= 50) {
      // Contoh: 25g - 50g = Normal
      statusGulaHariIni.value = SugarStatus.normal;
    } else {
      // Contoh: di atas 50g = High
      statusGulaHariIni.value = SugarStatus.high;
    }
  }
  // --- Akhir Tambahan ---

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

      // MODIFIKASI: Panggil fungsi kalkulasi setelah data didapat
      _hitungDanSetStatusGulaHarian();
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

      // MODIFIKASI: Panggil fungsi kalkulasi setelah data didapat
      _hitungDanSetStatusGulaHarian();
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
      // Memanggil fetchJurnal akan otomatis memanggil kalkulasi juga
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

    // --- TAMBAHAN: Reset state baru ---
    totalGulaHariIni.value = 0.0;
    statusGulaHariIni.value = SugarStatus.none;
    // --- Akhir Tambahan ---
  }
}

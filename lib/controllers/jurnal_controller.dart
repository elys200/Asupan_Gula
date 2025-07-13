import '../models/jurnal_entry.dart';
import '../services/jurnal_service.dart';
import 'package:get/get.dart';

class JurnalController extends GetxController {
  final JurnalApiService apiService;

  RxList<JurnalEntry> jurnalList = <JurnalEntry>[].obs;
  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs;
  RxString error = ''.obs;
  RxBool hasMore = true.obs;

  int currentPage = 1;
  final int perPage = 10;
  int? userId;

  RxInt totalEntries = 0.obs;

  JurnalController(this.apiService);

  void setUserId(int id) {
    userId = id;
  }

  Future<void> fetchJurnal({bool refresh = false}) async {
    if (userId == null) {
      error.value = 'User ID not set';
      return;
    }

    if (refresh) {
      currentPage = 1;
      hasMore.value = true;
      jurnalList.clear();
    }

    if (!hasMore.value && !refresh) return;

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

      // apakah sudah di halaman terakhir?
      hasMore.value = currentPage < result.lastPage;

      if (hasMore.value) {
        currentPage++;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!isLoading.value && !isFetchingMore.value && hasMore.value) {
      isFetchingMore.value = true;
      await fetchJurnal();
      isFetchingMore.value = false;
    }
  }

  Future<void> tambahJurnal(JurnalEntry entry) async {
    if (userId == null) {
      error.value = 'User ID not set';
      return;
    }

    try {
      await apiService.tambahJurnal(entry, userId!);
      await fetchJurnal(refresh: true);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> hapusJurnal(int id) async {
    if (userId == null) {
      error.value = 'User ID not set';
      return;
    }

    try {
      await apiService.hapusJurnal(id);
      await fetchJurnal(refresh: true);
    } catch (e) {
      error.value = e.toString();
    }
  }
}

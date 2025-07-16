import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/jurnal_controller.dart';
import '../services/jurnal_service.dart';
import '../controllers/profile_controller.dart';

class JurnalPage extends StatefulWidget {
  const JurnalPage({Key? key}) : super(key: key);

  @override
  State<JurnalPage> createState() => _JurnalPageState();
}

class _JurnalPageState extends State<JurnalPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late JurnalController _controller;
  late ScrollController _scrollController;
  late final ProfileController profileController;
  
  // Replace filter with date search
  TextEditingController _dateSearchController = TextEditingController();
  DateTime? _selectedDate;
  
  RxBool isReady = false.obs;

  @override
  void initState() {
    super.initState();
    profileController = Get.put(ProfileController());
    profileController.fetchProfile();

    _scrollController = ScrollController()..addListener(_scrollListener);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadUserIdAndToken();

    _animationController.forward();
  }

  Future<void> _loadUserIdAndToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getInt('user_id') ?? 1;

    _controller = Get.put(
      JurnalController(JurnalApiService(token: token)),
      permanent: true,
    );

    _controller.setUserId(userId);
    _controller.setToken(token);

    await _controller.fetchJurnal(refresh: true);

    isReady.value = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _dateSearchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _controller.loadMore();
    }
  }

  // Helper method untuk mengonversi hex color ke Color
  Color _hexToColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');

      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }

      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.green;
    }
  }

  // Helper methods untuk menghitung jumlah entri jurnal dalam seminggu
  int _getWeeklyCount() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _controller.jurnalList.where((entry) {
      final entryDate = DateTime.tryParse(entry.tanggal);
      return entryDate != null && entryDate.isAfter(weekStart);
    }).length;
  }

  String _getAverageCalories() {
    final filteredList = _getFilteredJurnalList();
    if (filteredList.isEmpty) return "0";
    final totalCalories = filteredList.fold<double>(
      0,
      (sum, entry) => sum + (entry.totalKalori ?? 0),
    );
    final average = totalCalories / filteredList.length;
    return (average / 1000).toStringAsFixed(1);
  }

  // Method untuk mendapatkan jumlah entri berdasarkan filter tanggal
  int _getFilteredCount() {
    return _getFilteredJurnalList().length;
  }

  // Method untuk filter berdasarkan tanggal
  void _filterByDate(DateTime? date) {
    setState(() {
      _selectedDate = date;
    });
    
    if (date != null) {
      _dateSearchController.text = "${date.day}/${date.month}/${date.year}";
    } else {
      _dateSearchController.clear();
    }
    
    // Refresh data dari controller
    _controller.fetchJurnal(refresh: true);
  }

  // Method untuk filter list jurnal berdasarkan tanggal yang dipilih
  List<dynamic> _getFilteredJurnalList() {
    if (_selectedDate == null) {
      return _controller.jurnalList;
    }
    
    final selectedDateStr = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    
    return _controller.jurnalList.where((entry) {
      final entryDate = entry.tanggal;
      return entryDate == selectedDateStr;
    }).toList();
  }

  // Method untuk membuka date picker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE43A15),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _filterByDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Obx(() {
          if (!isReady.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Header Section
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE43A15),
                      Color(0xFFE65245),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.06,
                  screenHeight * 0.02,
                  screenWidth * 0.06,
                  screenHeight * 0.03,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushReplacementNamed('/perhitungan_gula'),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: screenWidth * 0.05,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(() {
                                final user = profileController.user.value;
                                return Text(
                                  "Hi, ${user?.username ?? 'User'}!",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }),
                              SizedBox(height: screenHeight * 0.005),
                              Text(
                                "Rekam Jejak\nMakanmu",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: screenWidth * 0.06,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Obx(() => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildQuickStat(
                                  _selectedDate != null ? "Filtered" : "Entries",
                                  "${_getFilteredCount()}",
                                  Icons.bookmark),
                              _buildQuickStat("This Week",
                                  "${_getWeeklyCount()}", Icons.calendar_today),
                              _buildQuickStat(
                                  "Avg Cal",
                                  "${_getAverageCalories()}k",
                                  Icons.local_fire_department),
                            ],
                          ),
                        )),
                  ],
                ),
              ),

              // Date Search Section (Replace Filter Buttons)
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dateSearchController,
                        readOnly: true,
                        onTap: _selectDate,
                        decoration: InputDecoration(
                          hintText: "Pilih tanggal untuk filter",
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFFE43A15),
                          ),
                          suffixIcon: _selectedDate != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _filterByDate(null),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE43A15),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE43A15), Color(0xFFE65245)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE43A15).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _selectDate,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: screenWidth * 0.06,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Journal Entries
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Obx(() {
                    if (_controller.isLoading.value &&
                        _controller.jurnalList.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_controller.error.value.isNotEmpty) {
                      return _buildErrorState(screenWidth, screenHeight);
                    }

                    // Get filtered list based on selected date
                    final filteredList = _getFilteredJurnalList();

                    if (filteredList.isEmpty) {
                      return _buildEmptyState(screenWidth, screenHeight);
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredList.length,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      itemBuilder: (context, index) {
                        final entry = filteredList[index];
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, (1 - value) * 50),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: JurnalCard(
                            tanggal: entry.tanggal,
                            waktuMakan: entry.waktuMakan,
                            status: entry.status ?? '-',
                            statusColor:
                                _hexToColor(entry.statusColor ?? '#000000'),
                            jam: entry.jam ?? '-',
                            kalori: (entry.totalKalori ?? 0).toStringAsFixed(0),
                            karbo: (entry.totalKarbo ?? 0).toStringAsFixed(0),
                            lemak: (entry.totalLemak ?? 0).toStringAsFixed(0),
                            gula: entry.totalGula.toStringAsFixed(0),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildErrorState(double screenWidth, double screenHeight) {
    return Obx(() => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: screenWidth * 0.15,
                  color: Colors.red.shade400,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Terjadi kesalahan",
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade600,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                _controller.error.value,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.red.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: () => _controller.fetchJurnal(),
                child: const Text("Coba Lagi"),
              ),
            ],
          ),
        ));
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(double screenWidth, double screenHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: screenWidth * 0.15,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            _selectedDate != null 
                ? "Tidak ada data pada tanggal ini"
                : "Belum ada data jurnal",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            _selectedDate != null 
                ? "Coba pilih tanggal lain atau hapus filter"
                : "Mulai catat makananmu hari ini!",
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
class JurnalCard extends StatelessWidget {
  final String tanggal, waktuMakan, status, jam, kalori, karbo, lemak, gula;
  final Color statusColor;

  const JurnalCard({
    required this.tanggal,
    required this.waktuMakan,
    required this.status,
    required this.statusColor,
    required this.jam,
    required this.kalori,
    required this.karbo,
    required this.lemak,
    required this.gula,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            statusColor.withOpacity(0.1),
                            statusColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getTimeIcon(waktuMakan),
                        color: statusColor,
                        size: screenWidth * 0.06,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tanggal,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.01),
                          Text(
                            waktuMakan,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          jam,
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.01),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.015),
                              Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: screenWidth * 0.04),

                // Nutrition Info
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildNutritionItem(
                            "Kalori",
                            kalori,
                            "kkal",
                            Icons.local_fire_department,
                            Colors.orange,
                            screenWidth),
                      ),
                      Expanded(
                        child: _buildNutritionItem("Karbo", karbo, "g",
                            Icons.grain, Colors.brown, screenWidth),
                      ),
                      Expanded(
                        child: _buildNutritionItem("Lemak", lemak, "g",
                            Icons.opacity, Colors.yellow.shade700, screenWidth),
                      ),
                      Expanded(
                        child: _buildNutritionItem("Gula", gula, "g",
                            Icons.cake, Colors.pink, screenWidth),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth * 0.04),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showDetailDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE43A15),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Lihat Detail",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, String unit,
      IconData icon, Color color, double screenWidth) {
    return Column(
      children: [
        Icon(icon, color: color, size: screenWidth * 0.05),
        SizedBox(height: screenWidth * 0.02),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.035,
            color: Colors.grey.shade800,
          ),
        ),
        Text(
          "$label ($unit)",
          style: TextStyle(
            fontSize: screenWidth * 0.025,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  IconData _getTimeIcon(String waktuMakan) {
    switch (waktuMakan.toLowerCase()) {
      case 'sarapan':
        return Icons.wb_sunny;
      case 'makan siang':
        return Icons.wb_sunny_outlined;
      case 'makan malam':
        return Icons.nightlight_round;
      default:
        return Icons.restaurant;
    }
  }

  void _showDetailDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withOpacity(0.1),
                        statusColor.withOpacity(0.05)
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(_getTimeIcon(waktuMakan),
                          color: statusColor, size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Makanan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                            Text(
                              waktuMakan,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        iconSize: screenWidth * 0.06,
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tanggal,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.03),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Status: $status",
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text(
                          'Ringkasan Nutrisi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.03),
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildNutritionRow('Kalori', kalori, 'kkal',
                                  Icons.local_fire_department, Colors.orange),
                              _buildNutritionRow('Gula', gula, 'gram',
                                  Icons.cake, Colors.pink),
                              _buildNutritionRow('Karbohidrat', karbo, 'gram',
                                  Icons.grain, Colors.brown),
                              _buildNutritionRow('Lemak', lemak, 'gram',
                                  Icons.opacity, Colors.yellow.shade700),
                            ],
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text(
                          'Daftar Makanan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.03),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.035),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Tutup'),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionRow(
      String label, String value, String unit, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text('$label: '),
          Text(
            '$value $unit',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

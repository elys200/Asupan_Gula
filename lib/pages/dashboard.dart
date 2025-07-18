import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:sweetsense/controllers/authentication.dart'; // <-- 1. TAMBAHKAN IMPORT INI
import 'package:sweetsense/controllers/jurnal_controller.dart';
import 'package:sweetsense/controllers/profile_controller.dart';
import 'package:sweetsense/models/food_model.dart';
import 'package:sweetsense/controllers/food_controller.dart';
import 'package:sweetsense/models/news_model.dart';
import 'package:sweetsense/controllers/news_controller.dart';
import 'package:sweetsense/services/jurnal_service.dart';

enum SugarStatus { none, low, normal, high }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // --- 2. MODIFIKASI INISIALISASI CONTROLLER ---
  // Ambil token dari AuthController
  final AuthenticationController authController = Get.find<AuthenticationController>();

  // Inisialisasi controller lain dengan dependency yang dibutuhkan
  late final JurnalController jurnalController;
  final ProfileController profileController = Get.find<ProfileController>();
  // --- Akhir Modifikasi ---

  List<FoodModel> foods = [];
  bool isLoadingFoods = true;
  String? foodLoadError;

  List<NewsModel> news = [];
  bool isLoadingNews = true;
  String? newsLoadError;

  int currentIndex = 0;

  // Helper method untuk mendapatkan warna status
  Color getStatusColor(SugarStatus status) {
    switch (status) {
      case SugarStatus.low:
        return const Color(0xFF4CAF50);
      case SugarStatus.normal:
        return const Color(0xFF2196F3);
      case SugarStatus.high:
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  // Widget untuk status box
  Widget _buildStatusBox(SugarStatus status, String label,
      SugarStatus selectedStatusFromController) {
    bool isSelected = status == selectedStatusFromController;
    final color = getStatusColor(status);

    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 3,
                width: 24,
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: const Icon(
        Icons.person,
        size: 28,
        color: Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // --- 3. PINDAHKAN INISIALISASI JURNAL CONTROLLER KE SINI ---
    // Pastikan token diambil sebelum JurnalApiService dibuat
    final token = authController.token.value ?? '';
    jurnalController =
        Get.put(JurnalController(JurnalApiService(token: token)));
    // --- Akhir Perubahan ---

    profileController.fetchProfile();
    jurnalController.fetchJurnal(refresh: true);
    fetchFoods();
    fetchNews();
  }

  Future<void> fetchFoods() async {
    try {
      final fetchedFoods = await FoodController.getTop3Foods();
      if (mounted) {
        setState(() {
          foods = fetchedFoods;
          isLoadingFoods = false;
          foodLoadError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          foodLoadError = e.toString();
          isLoadingFoods = false;
        });
      }
    }
  }

  Future<void> fetchNews() async {
    try {
      final fetchedNews = await NewsController.getAllNews();
      if (mounted) {
        setState(() {
          news = fetchedNews.take(3).toList();
          isLoadingNews = false;
          newsLoadError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          newsLoadError = e.toString();
          isLoadingNews = false;
        });
      }
    }
  }

  void _navigateToJurnal() {
    Navigator.pushNamed(context, '/jurnal');
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEEE\nd/M/y').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        final user = profileController.user.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 230,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: SmoothBottomCurveClipper(),
                          child: Container(
                            height: 280,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFE43A15), Color(0xFFE65245)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          left: 20,
                          right: 20,
                          child: SafeArea(
                            child: Row(
                              children: [
                                user?.foto != null && user!.foto!.isNotEmpty
                                    ? Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            width: 3,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: Image.network(
                                            user.foto!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    _buildAvatarPlaceholder(),
                                          ),
                                        ),
                                      )
                                    : _buildAvatarPlaceholder(),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Hello,',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${user?.username ?? "User"}!',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Kartu status gula
                  Transform.translate(
                    offset: const Offset(0, -100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        elevation: 12,
                        shadowColor: Colors.black.withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Today Sugar',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color(0xFF2C3E50),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE43A15)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      formattedDate,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFE43A15),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '${jurnalController.totalGulaHariIni.value.toStringAsFixed(1)} gram',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildStatusBox(SugarStatus.low, 'Low',
                                      jurnalController.statusGulaHariIni.value),
                                  _buildStatusBox(SugarStatus.normal, 'Normal',
                                      jurnalController.statusGulaHariIni.value),
                                  _buildStatusBox(SugarStatus.high, 'High',
                                      jurnalController.statusGulaHariIni.value),
                                ],
                              ),
                              const SizedBox(height: 24),
                              GestureDetector(
                                onTap: _navigateToJurnal,
                                child: Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFE43A15),
                                        Color(0xFFE65245)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFE43A15)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit_note,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Jurnal',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
              // Sisa UI tidak berubah...
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Food Recommendation",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/food');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFE43A15),
                      ),
                      child: const Text(
                        "See all",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Food Carousel
              if (isLoadingFoods)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(
                    color: Color(0xFFE43A15),
                  ),
                )
              else if (foodLoadError != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Failed to load food recommendations',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: fetchFoods,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE43A15),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else if (foods.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No food recommendations available',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              else
                CarouselSlider.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index, realIndex) {
                    final food = foods[index];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/food_detail',
                        arguments: food,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: food.fotoUrl != null &&
                                  food.fotoUrl!.isNotEmpty
                              ? Image.network(
                                  food.fotoUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(
                                      Icons.restaurant_menu,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),

              const SizedBox(height: 32),

              // News Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "News",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/news');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFE43A15),
                      ),
                      child: const Text(
                        "See all",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // News Carousel
              if (isLoadingNews)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(
                    color: Color(0xFFE43A15),
                  ),
                )
              else if (newsLoadError != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Failed to load news',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: fetchNews,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE43A15),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (news.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.newspaper,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No news available',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              else
                CarouselSlider.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index, realIndex) {
                    final newsItem = news[index];
                    return GestureDetector(
                      onTap: () =>
                          Get.toNamed('/news_detail', arguments: newsItem),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              newsItem.fotoUrl != null &&
                                      newsItem.fotoUrl!.isNotEmpty
                                  ? Image.network(
                                      newsItem.fotoUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(
                                          Icons.newspaper,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        newsItem.judul,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('dd MMM yyyy')
                                            .format(newsItem.tanggalterbit),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 160,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),

              const SizedBox(height: 100),
            ],
          ),
        );
      }),
    );
  }
}

class SmoothBottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 82);

    var controlPoint = Offset(size.width / 2, size.height - 164);
    var endPoint = Offset(size.width, size.height - 82);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
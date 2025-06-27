import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:sweetsense/controllers/profile_controller.dart';
import 'package:sweetsense/models/food_model.dart';
import 'package:sweetsense/controllers/food_controller.dart';
import 'package:sweetsense/models/news_model.dart';
import 'package:sweetsense/controllers/news_controller.dart';

enum SugarStatus { none, low, normal, high }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProfileController profileController = Get.find<ProfileController>();

  List<FoodModel> foods = [];
  bool isLoadingFoods = true;
  String? foodLoadError;

  List<NewsModel> news = [];
  bool isLoadingNews = true;
  String? newsLoadError;

  int currentIndex = 0;
  SugarStatus _selectedStatus = SugarStatus.none;

  Widget _buildStatusBox(SugarStatus status, String label) {
    bool isSelected = _selectedStatus == status;

    final Border border;
    if (status == SugarStatus.low) {
      const double boldWidth = 1.5;
      border = Border.all(color: Colors.grey.shade400, width: boldWidth);
    } else {
      border = Border(
        top: BorderSide(color: Colors.grey.shade400, width: 1.5),
        bottom: BorderSide(color: Colors.grey.shade400, width: 1.5),
        right: BorderSide(color: Colors.grey.shade400, width: 1.5),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: Column(
        children: [
          Container(
            height: 30,
            width: 70,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE65245) : Colors.grey[300],
              border: border,
            ),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    profileController.fetchProfile();
    fetchFoods();
    fetchNews();
  }

  Future<void> fetchFoods() async {
    try {
      final fetchedFoods = await FoodController.getTop3Foods();
      setState(() {
        foods = fetchedFoods;
        isLoadingFoods = false;
        foodLoadError = null;
      });
    } catch (e) {
      setState(() {
        foodLoadError = e.toString();
        isLoadingFoods = false;
      });
    }
  }

  Future<void> fetchNews() async {
    try {
      final fetchedNews = await NewsController.getAllNews();
      setState(() {
        news = fetchedNews.take(3).toList();
        isLoadingNews = false;
        newsLoadError = null;
      });
    } catch (e) {
      setState(() {
        newsLoadError = e.toString();
        isLoadingNews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEEE\nd/M/y').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final user = profileController.user.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  ClipPath(
                    clipper: BottomCurveClipper(),
                    child: Container(
                      height: 200,
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
                    top: 60,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: user?.foto != null &&
                                  user!.foto!.isNotEmpty
                              ? NetworkImage(user.foto!) as ImageProvider
                              : const AssetImage('assets/images/portrait.png'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Hello,\n${user?.username ?? "User"}!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Today Sugar',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text('Status',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    formattedDate,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildStatusBox(SugarStatus.low, 'Low'),
                                _buildStatusBox(SugarStatus.normal, 'Normal'),
                                _buildStatusBox(SugarStatus.high, 'High'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/jurnal');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF94F45),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  'Jurnal',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 180),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Food Recommendation",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/food');
                      },
                      child: const Text("See all"),
                    ),
                  ],
                ),
              ),
              if (isLoadingFoods)
                const Center(child: CircularProgressIndicator())
              else if (foodLoadError != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Failed to load food recommendations.\n$foodLoadError',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (foods.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No food recommendations available'),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: food.fotoUrl != null && food.fotoUrl!.isNotEmpty
                            ? Image.network(
                                food.fotoUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                  child: Icon(Icons.broken_image,
                                      size: 40, color: Colors.grey),
                                ),
                              )
                            : Image.asset(
                                'assets/images/food_placeholder.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "News",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/news');
                      },
                      child: const Text("See all"),
                    ),
                  ],
                ),
              ),
              if (isLoadingNews)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (newsLoadError != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Failed to load news.\n$newsLoadError',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (news.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No news available'),
                )
              else
                CarouselSlider.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index, realIndex) {
                    final newsItem = news[index];
                    return GestureDetector(
                      onTap: () =>
                          Get.toNamed('/news_detail', arguments: newsItem),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: newsItem.fotoUrl != null &&
                                    newsItem.fotoUrl!.isNotEmpty
                                ? Image.network(
                                    newsItem.fotoUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/news_placeholder.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                    );
                  },
                  options: CarouselOptions(
                    height: 150,
                    autoPlay: true,
                    enlargeCenterPage: true,
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

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);

    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 60);

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

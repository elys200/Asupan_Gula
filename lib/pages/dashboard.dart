import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:sweetsense/controllers/profile_controller.dart';
import 'package:sweetsense/models/food_model.dart';
import 'package:sweetsense/controllers/food_controller.dart';

// Enum to manage the state of the sugar status selector
enum SugarStatus { none, low, normal, high }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProfileController profileController = Get.find<ProfileController>();

  // Backend variables - TETAP DIPERTAHANKAN
  List<FoodModel> foods = [];
  bool isLoadingFoods = true;
  String? foodLoadError;

  final List<String> newsImages = [
    'assets/images/news1.png',
    'assets/images/news2.png',
    'assets/images/news3.png',
  ];

  int currentIndex = 0;
  // State variable to track the selected sugar status
  SugarStatus _selectedStatus = SugarStatus.none;

  // Helper method to build the status selector boxes - FRONTEND BARU
  Widget _buildStatusBox(SugarStatus status, String label) {
    bool isSelected = _selectedStatus == status;

    // Define custom borders for each box to make them stick together
    final Border border;
    if (status == SugarStatus.low) {
      // The first box has a full border
      const double boldWidth = 1.5;
      border = Border.all(color: Colors.grey.shade400, width: boldWidth);
    } else {
      // Subsequent boxes have no left border to connect seamlessly
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
            width: 70, // Made width smaller for a more compact look
            // The margin property has been removed to allow boxes to stick together
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
    // Backend initialization - TETAP DIPERTAHANKAN
    profileController.fetchProfile();
    fetchFoods();
  }

  // Backend method - TETAP DIPERTAHANKAN
  Future<void> fetchFoods() async {
    try {
      final fetchedFoods = await FoodController.getAllFoods();
      setState(() {
        foods = fetchedFoods.take(3).toList();
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

  @override
  Widget build(BuildContext context) {
    // Formatting the date to match the UI
    final String formattedDate =
        DateFormat('EEEE\nd/M/y').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final user = profileController.user.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Top Greeting with new frontend design
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
                  // The new "Today Sugar" card is positioned to overlap the header slightly
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
                            // Interactive Status Selector
                            Row(
                              // Changed to MainAxisAlignment.start to align the group of boxes to the left
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildStatusBox(SugarStatus.low, 'Low'),
                                _buildStatusBox(SugarStatus.normal, 'Normal'),
                                _buildStatusBox(SugarStatus.high, 'High'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Jurnal Button
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
              // Added space to account for the new, larger card
              const SizedBox(height: 180),

              // Food Recommendation Section
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

              // Food Recommendation dengan Backend Logic - BACKEND TETAP DIPERTAHANKAN
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
                                    Image.asset('assets/images/placeholder.png',
                                        fit: BoxFit.cover),
                              )
                            : Image.asset(
                                'assets/images/placeholder.png',
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

              // News Section
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CarouselSlider(
                  items: newsImages.map((assetPath) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/news');
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              assetPath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Headlines !!',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 150,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
    path.lineTo(0, size.height - 60); // Start point adjusted for card overlap

    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 60); // End point adjusted

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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> imageAssets = [
    'assets/images/rekomen1.png',
    'assets/images/rekomen2.png',
    'assets/images/rekomen3.png',
  ];

  final List<String> newsImages = [
    'assets/images/news1.png',
    'assets/images/news2.png',
    'assets/images/news3.png',
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Greeting
            Stack(
              children: [
                // Curved red-orange background
                ClipPath(
                  clipper: BottomCurveClipper(),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.redAccent, Colors.orangeAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),

                // Greeting and Avatar
                Positioned(
                  top: 60,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          'assets/images/portrait.png',
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Hello,\nElys!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Sugar Status Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Today Sugar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Low'),
                          Container(
                            width: 60,
                            height: 20,
                            color: Colors.grey[300],
                          ),
                          Text('Normal'),
                          Container(
                            width: 60,
                            height: 20,
                            color: Colors.grey[300],
                          ),
                          Text('High'),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Start Calculate'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Food Recommendation Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Food Recommendation",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/food');
                    },
                    child: Text("See all"),
                  ),
                ],
              ),
            ),

            // Food Recommendation Carousel
            CarouselSlider(
              items:
                  imageAssets.map((assetPath) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  }).toList(),
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

            SizedBox(height: 20),

            // News Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "News",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/news');
                    },
                    child: Text("See all"),
                  ),
                ],
              ),
            ),

            // News Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CarouselSlider(
                items:
                    newsImages.map((assetPath) {
                      return Stack(
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
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Headlines !!',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                options: CarouselOptions(
                  height: 150,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        currentIndex: 1,
        onTap: (index) {},
      ),
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

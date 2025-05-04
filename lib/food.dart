import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        backgroundColor: Colors.red,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          ); // This pops the current screen
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Hi Mia",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/portrait.png',
                        ),
                        radius: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Find your food",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search food",
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Food Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) => FoodCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.asset(
                  'assets/images/food2.png',
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Vegetable salad",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text("220 kcal", style: TextStyle(color: Colors.grey)),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "More Detail",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Icon(Icons.star_border, color: Colors.grey),
        ),
      ],
    );
  }
}

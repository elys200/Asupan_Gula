import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  Widget buildBeritaCard() {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/news1.png',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Studi: Diet Rendah Karbohidrat Efektif Turunkan dalam 3 Bulan',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Chip(
              label: Text(
                'Lihat Detail',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: List.generate(2, (_) => buildBeritaCard())),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi Elys",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Discover today's headlines",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/portrait.png'),
                    radius: 20,
                  ),
                ],
              ),
            ),
            buildSection("Rekomendasi"),
            buildSection("Terbaru"),
            buildSection("Fakta Terpilih"),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

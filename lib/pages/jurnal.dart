import 'package:flutter/material.dart';

class JurnalPage extends StatelessWidget {
  const JurnalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> jurnalData = [
      {
        'tanggal': 'Senin, 10 April 2025',
        'status': 'Normal',
        'statusColor': Colors.green,
        'jam': '08:40 PM',
        'kalori': '220',
        'karbo': '50',
        'lemak': '12',
        'gula': '24',
      },
      {
        'tanggal': 'Rabu, 12 April 2025',
        'status': 'Low',
        'statusColor': Colors.yellow,
        'jam': '08:40 PM',
        'kalori': '180',
        'karbo': '40',
        'lemak': '10',
        'gula': '20',
      },
      {
        'tanggal': 'Kamis, 13 April 2025',
        'status': 'Normal',
        'statusColor': Colors.green,
        'jam': '08:40 PM',
        'kalori': '225',
        'karbo': '48',
        'lemak': '11',
        'gula': '23',
      },
      {
        'tanggal': 'Sabtu, 15 April 2025',
        'status': 'High',
        'statusColor': Colors.red,
        'jam': '08:40 PM',
        'kalori': '298',
        'karbo': '60',
        'lemak': '15',
        'gula': '30',
      },
      {
        'tanggal': 'Minggu, 16 April 2025',
        'status': 'High',
        'statusColor': Colors.red,
        'jam': '08:40 PM',
        'kalori': '285',
        'karbo': '55',
        'lemak': '14',
        'gula': '28',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        currentIndex: 1,
        onTap: (index) {},
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFE774C), Color(0xFFF44336)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hi Mia",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Rekam Jejak\nMakanmu",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                FilterButton(label: "Today", selected: false),
                FilterButton(label: "Weekly", selected: true),
                FilterButton(label: "Monthly", selected: false),
                FilterButton(label: "Yearly", selected: false),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jurnalData.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final item = jurnalData[index];
                return JurnalCard(
                  tanggal: item['tanggal'],
                  status: item['status'],
                  statusColor: item['statusColor'],
                  jam: item['jam'],
                  kalori: item['kalori'],
                  karbo: item['karbo'],
                  lemak: item['lemak'],
                  gula: item['gula'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  const FilterButton({required this.label, required this.selected, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.red : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        boxShadow: selected
            ? [BoxShadow(color: Colors.red.shade200, blurRadius: 4)]
            : [],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class JurnalCard extends StatelessWidget {
  final String tanggal, status, jam, kalori, karbo, lemak, gula;
  final Color statusColor;

  const JurnalCard({
    required this.tanggal,
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'images/food2.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tanggal,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("Status: "),
                      Icon(Icons.circle, color: statusColor, size: 12),
                      const SizedBox(width: 4),
                      Text(status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      NutritionItem(label: 'Kalori', value: kalori),
                      NutritionItem(label: 'Karbo', value: karbo),
                      NutritionItem(label: 'Lemak', value: lemak),
                      NutritionItem(label: 'Gula', value: gula),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                Text(jam, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Lihat Detail",
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NutritionItem extends StatelessWidget {
  final String label;
  final String value;

  const NutritionItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

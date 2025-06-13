import 'package:flutter/material.dart';

class HitungPage extends StatefulWidget {
  const HitungPage({super.key});

  @override
  State<HitungPage> createState() => _HitungPageState();
}

class _HitungPageState extends State<HitungPage> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tanpa bottomNavigationBar
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Bagian atas lengkung merah
          Stack(
            children: [
              Container(
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 25,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          // Konten halaman
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Senin, 10 April 2025',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Waktu: 08.00',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      'images/food2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Vegetable salad',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Lorem ipsum odor amet, consectetur adipis cing elit. '
                  'Ex sit sapien ante lobortis massa hac. Vestibulum hendrerit hac '
                  'curabitur justo praesent a felis. Lacinia curabitur\n\n'
                  'Lorem ipsum odor amet, consectetur adipis cing elit. '
                  'Ex sit sapien ante lobortis massa hac. Vestibulum hendrerit hac '
                  'curabitur justo praesent a felis. Lacinia curabitur',
                  style: const TextStyle(fontSize: 14),
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        isExpanded ? "Read Less" : "Read More",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: CircularProgressIndicator(
                                    value: 0.83,
                                    strokeWidth: 12,
                                    backgroundColor: Colors.green,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                                  ),
                                ),
                                const Text(
                                  '250\nmg/dL',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Sesudah Makan',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                _NutrisiInfo(label: 'Karbohidrat', value: '110g', color: Colors.green),
                                _NutrisiInfo(label: 'Protein', value: '11g', color: Colors.purple),
                                _NutrisiInfo(label: 'Lemak', value: '7g', color: Colors.blue),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 16,
                        child: Row(
                          children: const [
                            Icon(Icons.circle, color: Colors.red, size: 12),
                            SizedBox(width: 6),
                            Text('High', style: TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NutrisiInfo extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _NutrisiInfo({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.circle, size: 12, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

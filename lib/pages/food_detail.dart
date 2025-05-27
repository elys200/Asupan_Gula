import 'package:flutter/material.dart';

class FoodDetailPage extends StatelessWidget {
  const FoodDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header image & back button
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE43A15), Color(0xFFE65245)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              "Detail Makanan",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite_border, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/food2.png',
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Icon(Icons.favorite, color: Colors.red),
                        const Text("100k", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  Positioned(
                   bottom: -30,
                   left: 0,
                   right: 0,
                   child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                   ) ,
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vegetable salad",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Nutrition info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        NutritionInfo(label: 'Kalori', value: '220'),
                        NutritionInfo(label: 'Karbohidrat', value: '100'),
                        NutritionInfo(label: 'Lemak', value: '20'),
                        NutritionInfo(label: 'Gula', value: '2g'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Lorem ipsum dolor amet, consectetur adip... '
                      'Vestibulum hendrerit hac curabitur justo praesent a felis. Lacinia curabitur',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    const Text("Read More", style: TextStyle(color: Colors.blue)),

                    const SizedBox(height: 24),
                    const Text("Ingredients", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          IngredientItem(image: 'assets/images/bahan1.png', label: 'Selada'),
                          IngredientItem(image: 'assets/images/bahan2.png', label: 'Tomat Cherry'),
                          IngredientItem(image: 'assets/images/bahan3.png', label: 'Kubis/Kol'),
                          IngredientItem(image: 'assets/images/bahan4.png', label: 'Tahu Putih'),
                          IngredientItem(image: 'assets/images/bahan5.png', label: 'Mayonaise'),

                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text("Instructions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const InstructionItem(number: 1, text: "Cuci bersih semua sayuran."),
                    const InstructionItem(number: 2, text: "Iris/potong sayuran sesuai selera."),
                    const InstructionItem(number: 3, text: "Rebus bahan tambahan (jagung, brokoli, telur) jika ada."),
                    const InstructionItem(number: 4, text: "Tata sayuran dan topping di mangkuk."),
                    const InstructionItem(number: 5, text: "Tuang atau sajikan saus/dressing."),
                    const InstructionItem(number: 6, text: "Sajikan salad dalam keadaan segar."),

                    const SizedBox(height: 24),
                    const Text("Tips", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF5E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TipItem(text: "Pastikan semua sayuran dicuci bersih dan dikeringkan."),
                          TipItem(text: "Gunakan es batu sebentar untuk membuat sayuran makin crunchy."),
                          TipItem(text: "Bisa disimpan di kulkas sebelum disajikan agar lebih segar."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NutritionInfo extends StatelessWidget {
  final String label;
  final String value;

  const NutritionInfo({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

class IngredientItem extends StatelessWidget {
  final String image;
  final String label;

  const IngredientItem({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(image, height: 40, width: 40, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class InstructionItem extends StatelessWidget {
  final int number;
  final String text;

  const InstructionItem({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(number.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class TipItem extends StatelessWidget {
  final String text;

  const TipItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

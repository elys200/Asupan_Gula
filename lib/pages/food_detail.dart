import 'package:flutter/material.dart';
import '../models/food_model.dart';

class FoodDetailPage extends StatefulWidget {
  final FoodModel food;

  const FoodDetailPage({super.key, required this.food});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

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
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              "Detail Makanan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite_border,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            food.fotoUrl ?? 'https://via.placeholder.com/200',
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 100, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                            "${food.totalKalori?.toStringAsFixed(0) ?? '0'} kcal",
                            style: const TextStyle(color: Colors.white)),
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
                    ),
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.nama,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Nutrition info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NutritionInfo(
                            label: 'Kalori',
                            value:
                                "${food.totalKalori?.toStringAsFixed(0) ?? '0'}"),
                        NutritionInfo(
                            label: 'Karbohidrat',
                            value:
                                "${food.totalKarbohidrat?.toStringAsFixed(0) ?? '0'}"),
                        NutritionInfo(
                            label: 'Lemak',
                            value:
                                "${food.totalLemak?.toStringAsFixed(0) ?? '0'}"),
                        NutritionInfo(
                            label: 'Gula',
                            value:
                                "${food.kadarGula?.toStringAsFixed(0) ?? '0'}g"),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi dengan Read More
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final span = TextSpan(
                          text: food.deskripsi,
                          style: const TextStyle(color: Colors.black54),
                        );
                        final tp = TextPainter(
                          maxLines: 3,
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          text: span,
                        );
                        tp.layout(maxWidth: constraints.maxWidth);

                        final isTextOverflow = tp.didExceedMaxLines;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.deskripsi,
                              style: const TextStyle(color: Colors.black54),
                              maxLines: isExpanded ? null : 3,
                              overflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            if (isTextOverflow)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Text(
                                  isExpanded ? "Read Less" : "Read More",
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    const Text("Ingredients",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // Bahan jadi bullet list tanpa foto
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: food.bahan.map((bahan) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("• ", style: TextStyle(fontSize: 18)),
                              Expanded(child: Text(bahan)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),
                    const Text("Instructions",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(food.panduan.length, (index) {
                        return InstructionItem(
                          number: index + 1,
                          text: food.panduan[index],
                        );
                      }),
                    ),

                    const SizedBox(height: 24),
                    const Text("Tips",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF5E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            food.tips.map((tip) => TipItem(text: tip)).toList(),
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
            child: Text(number.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
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

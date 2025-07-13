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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header + Floating Image
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.25,
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.03),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Spacer(),
                              const Text(
                                "Detail Makanan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(
                                  width:
                                      48), // Untuk menggantikan space icon favorit yang dihapus
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.17,
                    left: screenWidth / 2 - 60,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          food.fotoUrl ?? 'https://via.placeholder.com/200',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image,
                                  size: 100, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 80),

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama makanan
                    Center(
                      child: Text(
                        food.nama,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Nutrisi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NutritionInfo(
                            label: 'Kalori',
                            value:
                                "${food.totalKalori?.toStringAsFixed(0) ?? '0'} kj"),
                        NutritionInfo(
                            label: 'Karbohidrat',
                            value:
                                "${food.totalKarbohidrat?.toStringAsFixed(0) ?? '0'}g"),
                        NutritionInfo(
                            label: 'Lemak',
                            value:
                                "${food.totalLemak?.toStringAsFixed(0) ?? '0'}g"),
                        NutritionInfo(
                            label: 'Gula',
                            value:
                                "${food.kadarGula?.toStringAsFixed(0) ?? '0'}g"),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi
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

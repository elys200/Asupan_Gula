import 'package:flutter/material.dart';
import 'news_detail.dart'; // pastikan import ini benar sesuai lokasi file

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  static const double cardWidth = 180;
  static const double cardHeight = 210;

  // Dummy data berita
  final List<Map<String, String>> newsList = const [
    {
      "title": "Studi: Diet Rendah Karbohidrat Efektif Turunkan dalam 3 Bulan",
      "date": "2024-08-15",
      "author": "Prof.Sarah Tanuwijaya, Ph.D",
      "content": "Sebuah studi terbaru mengungkapkan bahwa diet rendah karbohidrat mampu menurunkan berat badan secara signifikan hanya dalam waktu tiga bulan. Dalam penelitian tersebut, peserta yang mengadopsi pola makan rendah karbohidrat mengalami penurunan berat badan yang lebih besar dibandingkan dengan mereka yang menjalani diet rendah lemak. Temuan ini memperkuat pandangan bahwa pengurangan asupan karbohidrat dapat menjadi metode yang efektif untuk mengatasi masalah berat badan dalam jangka pendek. Selain menurunkan berat badan, diet rendah karbohidrat juga menunjukkan dampak positif terhadap kesehatan metabolik. Studi mencatat adanya perbaikan pada kadar gula darah dan kolesterol peserta, yang mengindikasikan potensi manfaat lebih luas dari diet ini. Para peneliti pun menyimpulkan bahwa pola makan rendah karbohidrat bisa menjadi salah satu strategi yang layak dipertimbangkan untuk meningkatkan kesehatan secara keseluruhan, terutama bagi mereka yang memiliki masalah kelebihan berat badan atau gangguan metabolik.",
      "sourceTitle": "Health Magazine",
      "sourceImage": "assets/images/news1.png",
      "sourceUrl": "https://healthmagazine.com",
    },
    {
      "title": "Manfaat Jalan Pagi untuk Kesehatan Jantung",
      "date": "2025-05-20",
      "author": "Dr. Fitri",
      "content": "Jalan pagi secara rutin terbukti memberikan manfaat besar bagi kesehatan jantung. Aktivitas fisik ringan ini dapat membantu melancarkan peredaran darah, menurunkan tekanan darah, serta mengurangi kadar kolesterol jahat (LDL) dalam tubuh. Dengan berjalan kaki selama 30 menit setiap pagi, jantung bekerja lebih efisien dan risiko penyakit jantung seperti serangan jantung dan stroke dapat ditekan secara signifikan. Selain itu, jalan pagi juga dapat meningkatkan kualitas hidup secara keseluruhan. Aktivitas ini membantu mengurangi stres, meningkatkan suasana hati, dan menjaga berat badan tetap ideal—semua faktor yang turut mendukung kesehatan jantung. Para ahli kesehatan menyarankan untuk menjadikan jalan pagi sebagai bagian dari rutinitas harian, terutama bagi mereka yang ingin menjaga jantung tetap sehat tanpa harus melakukan olahraga berat.",
      "sourceTitle": "Daily Health",
      "sourceImage": "assets/images/news1.png",
      "sourceUrl": "https://dailyhealth.com",
    },
    // Tambahkan data berita lainnya
  ];

  Widget buildBeritaCard(BuildContext context, Map<String, String> newsItem) {
    return Container(
      width: cardWidth,
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
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              newsItem["sourceImage"]!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // TITLE
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              newsItem["title"]!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // BUTTON
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewsDetailPage(
                      date: newsItem["date"]!,
                      title: newsItem["title"]!,
                      author: newsItem["author"]!,
                      content: newsItem["content"]!,
                      sourceTitle: newsItem["sourceTitle"]!,
                      sourceImage: newsItem["sourceImage"]!,
                      sourceUrl: newsItem["sourceUrl"]!,
                    ),
                  ),
                );
              },
              child: const Chip(
                label: Text(
                  'Lihat Detail',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSection(BuildContext context, String title) {
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
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: newsList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => buildBeritaCard(context, newsList[index]),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            // === HEADER ===
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/portrait.png'),
                    radius: 20,
                  ),
                ],
              ),
            ),

            // === SECTIONS ===
            buildSection(context, "Rekomendasi"),
            buildSection(context, "Terbaru"),
            buildSection(context, "Fakta Terpilih"),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

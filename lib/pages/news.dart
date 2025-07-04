import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/news_model.dart';
import '../controllers/news_controller.dart';
import '../controllers/profile_controller.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<NewsModel>> futureNews;
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    futureNews = NewsController.getAllNews();
    profileController.fetchProfile();
  }

  Widget _buildAvatarPlaceholder({double radius = 20}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: radius, color: Colors.grey),
    );
  }

  Widget buildNewsCard(BuildContext context, NewsModel news) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = screenWidth * 0.5;

    return InkWell(
      onTap: () => Get.toNamed('/news_detail', arguments: news),
      child: Container(
        width: cardWidth,
        height: screenHeight * 0.28,
        margin: const EdgeInsets.only(left: 16),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: news.fotoUrl != null
                  ? Image.network(
                      news.fotoUrl!,
                      height: screenHeight * 0.12,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/default.png',
                      height: screenHeight * 0.12,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                news.judul,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
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
      ),
    );
  }

  Widget buildSection(
    BuildContext context,
    String title,
    List<NewsModel> allNews, {
    String? kategoriFilter,
  }) {
    final filteredNews = kategoriFilter == null
        ? allNews
        : allNews
            .where((news) =>
                news.kategori.toLowerCase() == kategoriFilter.toLowerCase())
            .toList();

    if (filteredNews.isEmpty) return const SizedBox();

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
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: filteredNews.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) =>
                buildNewsCard(context, filteredNews[index]),
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
        child: Obx(() {
          final user = profileController.user.value;

          return ListView(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + 20,
                  16,
                  20,
                ),
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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${user?.username ?? "User"}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          const Text(
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
                    user?.fotoUrl != null && user!.fotoUrl!.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(user.fotoUrl!),
                            radius: 20,
                          )
                        : _buildAvatarPlaceholder(radius: 20),
                  ],
                ),
              ),
              FutureBuilder<List<NewsModel>>(
                future: futureNews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Gagal memuat berita')),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Belum ada berita tersedia.')),
                    );
                  }

                  final newsList = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSection(context, "Rekomendasi", newsList,
                          kategoriFilter: "rekomendasi"),
                      buildSection(context, "Terbaru", newsList,
                          kategoriFilter: "terbaru"),
                      buildSection(context, "Fakta Terpilih", newsList,
                          kategoriFilter: "fakta terpilih"),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}

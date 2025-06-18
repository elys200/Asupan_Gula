import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_model.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsModel news;

  const NewsDetailPage({super.key, required this.news});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool isExpanded = false;

  Future<void> _launchSourceUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka link sumber')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final news = widget.news;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNewsImage(news.fotoUrl),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(news),
                    const SizedBox(height: 16),
                    _buildContent(news),
                    const SizedBox(height: 20),
                    _buildSource(news),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsImage(String? url) {
    return Stack(
      children: [
        url != null
            ? Image.network(
                url,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _placeholderImage(),
              )
            : _placeholderImage(),
        Positioned(
          top: 16,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: double.infinity,
      height: 240,
      color: Colors.grey[300],
      child: const Center(child: Icon(Icons.image, size: 50)),
    );
  }

  Widget _buildHeader(NewsModel news) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${news.tanggalterbit.toLocal()}".split(' ')[0],
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(
          news.judul,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.person, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              news.penulis,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(NewsModel news) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            news.deskripsi,
            style: const TextStyle(fontSize: 14, height: 1.5),
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSource(NewsModel news) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sumber",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _launchSourceUrl(news.link),
          child: Row(
            children: [
              const Icon(Icons.link, size: 20, color: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  news.sumber,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}

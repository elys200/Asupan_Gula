import 'package:flutter/material.dart';

class PerhitunganGulaPage extends StatelessWidget {
  const PerhitunganGulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perhitungan Gula'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.calculate, size: 100),
            SizedBox(height: 20),
            Text(
              'Halaman Perhitungan Gula',
              style: TextStyle(fontSize: 24),
            ),
            // Tambahkan kalkulator perhitungan gula di sini jika diperlukan
          ],
        ),
      ),
    );
  }
}

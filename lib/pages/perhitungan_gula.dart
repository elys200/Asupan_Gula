import 'package:flutter/material.dart';

class PerhitunganGulaPage extends StatefulWidget {
  const PerhitunganGulaPage({super.key});

  @override
  State<PerhitunganGulaPage> createState() => _PerhitunganGulaPageState();
}

class _PerhitunganGulaPageState extends State<PerhitunganGulaPage> {
  String? selectedWaktuMakan;
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _makananController =
      TextEditingController(text: 'Makan Siang');

  final List<String> waktuMakanOptions = [
    'Snack',
    'Makan Siang',
    'Makan Malam',
    'Sarapan',
    'Minuman',
    'Lainnya'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perhitungan'),
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/dashboard'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/portrait.png'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.redAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                CircleAvatar(
                  child: Icon(Icons.person, color: Colors.redAccent),
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Sudah cek Gula Darah Anda?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Input waktu
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _waktuController,
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text('Pilih waktu makan'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: waktuMakanOptions.map((option) {
                    return ChoiceChip(
                      label: Text(option),
                      selected: selectedWaktuMakan == option,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedWaktuMakan = selected ? option : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                const Text('Input Data Makanan'),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    title: TextField(
                      controller: _makananController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                    trailing: const Icon(Icons.add, color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika perhitungan di sini
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text('Hitung'),
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PerhitunganGulaPage extends StatefulWidget {
  const PerhitunganGulaPage({super.key});

  @override
  State<PerhitunganGulaPage> createState() => _PerhitunganGulaPageState();
}

class _PerhitunganGulaPageState extends State<PerhitunganGulaPage> {
  String? selectedWaktuMakan = 'Makan Siang';
  DateTime selectedDate = DateTime.now();
  final makananList = [
    {'nama': 'Telur Rebus', 'jumlah': '2 sedang'},
    {'nama': 'Salad Sayur', 'jumlah': '1 mangkok'},
    {'nama': 'Dada ayam', 'jumlah': '150 gram'},
  ];

  final waktuMakanOptions = [
    'Snack',
    'Makan Siang',
    'Makan Malam',
    'Sarapan',
    'Minuman',
    'Lainnya',
  ];

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _tambahMakanan() {
    String namaMakanan = '';
    String jumlahMakanan = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Makanan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nama Makanan'),
                onChanged: (value) {
                  namaMakanan = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Jumlah'),
                onChanged: (value) {
                  jumlahMakanan = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaMakanan.isNotEmpty && jumlahMakanan.isNotEmpty) {
                  setState(() {
                    makananList.add({
                      'nama': namaMakanan,
                      'jumlah': jumlahMakanan,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        title: const Text('Perhitungan'),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Gula darah prompt
            Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.redAccent),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Sudah cek Gula Darah Anda?',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Masukkan data terbarumu sekarang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Time Input (Date)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                title: const Text('Time'),
                subtitle: Text(DateFormat('dd MMMM yyyy').format(selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
            ),
            const SizedBox(height: 20),

            const Text('Pilih waktu makan'),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.5,
              children: waktuMakanOptions.map((option) {
                final isSelected = selectedWaktuMakan == option;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedWaktuMakan = option;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.redAccent : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: isSelected
                          ? Colors.redAccent.withOpacity(0.2)
                          : Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: Text(option),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedWaktuMakan ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.redAccent),
                  onPressed: _tambahMakanan,
                ),
              ],
            ),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: makananList.map((item) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(item['nama']!),
                        subtitle: Text(item['jumlah']!),
                      ),
                      const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic hitung di sini
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
    );
  }
}

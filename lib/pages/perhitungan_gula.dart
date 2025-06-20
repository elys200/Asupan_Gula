import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'jurnal.dart';
import 'openfood_api.dart';

class PerhitunganGulaPage extends StatefulWidget {
  const PerhitunganGulaPage({super.key});

  @override
  State<PerhitunganGulaPage> createState() => _PerhitunganGulaPageState();
}

class _PerhitunganGulaPageState extends State<PerhitunganGulaPage> {
  String selectedWaktuMakan = 'Makan Siang';
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> makananList = [
    {'nama': 'Telur Rebus', 'jumlah': '2 sedang', 'kalori': 155.0, 'gula': 1.1},
    {'nama': 'Salad Sayur', 'jumlah': '1 mangkok', 'kalori': 80.0, 'gula': 3.5},
    {'nama': 'Dada ayam', 'jumlah': '150 gram', 'kalori': 165.0, 'gula': 0.0},
  ];

  final waktuMakanOptions = [
    'Snack',
    'Makan Siang',
    'Makan Malam',
    'Sarapan',
    'Minuman',
    'Lainnya',
  ];

  final List<String> _makananSuggestions = [
    'Nasi Putih',
    'Nasi Goreng',
    'Telur Rebus',
    'Telur Dadar',
    'Dada Ayam',
    'Sate Ayam',
    'Rendang',
    'Gado-gado',
    'Salad Sayur',
    'Bakso',
    'Soto Ayam',
    'Roti Tawar',
    'Apel',
    'Pisang',
    'Jeruk',
    'Teh Manis',
    'Kopi Hitam',
  ];

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _tambahMakanan() {
    String jumlahMakanan = '';
    final TextEditingController typeAheadController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Makanan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TypeAheadField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: typeAheadController,
                  decoration: const InputDecoration(labelText: 'Nama Makanan'),
                ),
                suggestionsCallback: (pattern) {
                  return _makananSuggestions
                      .where((item) =>
                          item.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion));
                },
                onSuggestionSelected: (suggestion) {
                  typeAheadController.text = suggestion;
                },
                noItemsFoundBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Makanan tidak ditemukan.'),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Jumlah'),
                onChanged: (value) => jumlahMakanan = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String namaMakanan = typeAheadController.text.trim();
                if (namaMakanan.isNotEmpty && jumlahMakanan.isNotEmpty) {
                  Navigator.pop(context);

                  final hasil =
                      await OpenFoodFactsAPI.fetchNutrisiMakanan(namaMakanan);

                  setState(() {
                    makananList.add({
                      'nama': namaMakanan,
                      'jumlah': jumlahMakanan,
                      'kalori': hasil?.kalori ?? 0.0,
                      'gula': hasil?.gula ?? 0.0,
                    });
                  });

                  if (hasil != null) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Info Nutrisi: ${hasil.nama}'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kalori: ${hasil.kalori} kkal'),
                            Text('Gula: ${hasil.gula} gram'),
                            Text('Protein: ${hasil.protein} gram'),
                            Text('Lemak: ${hasil.lemak} gram'),
                            Text('Karbohidrat: ${hasil.karbohidrat} gram'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Data nutrisi tidak ditemukan')),
                    );
                  }
                }
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _showPopupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Data Perhitungan',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Waktu Makan: $selectedWaktuMakan'),
                const SizedBox(height: 8),
                Text(
                    'Total Kalori: ${getTotalKalori().toStringAsFixed(1)} kkal'),
                Text(
                    'Estimasi Gula: ${getTotalGula().toStringAsFixed(1)} gram'),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                const Text('Apakah Anda ingin melanjutkan?'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Kembali'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const JurnalPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent),
                        child: const Text('Lanjut'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hapusMakanan(int index) {
    setState(() {
      makananList.removeAt(index);
    });
  }

  double getTotalKalori() {
    return makananList.fold(0.0, (sum, item) => sum + (item['kalori'] ?? 0.0));
  }

  double getTotalGula() {
    return makananList.fold(0.0, (sum, item) => sum + (item['gula'] ?? 0.0));
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
              backgroundImage: AssetImage('assets/images/portrait.png'),
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
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
                  selectedWaktuMakan,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
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
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: makananList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      ListTile(
                        title: Text(item['nama']!),
                        subtitle: Text(
                          '${item['jumlah']} - ${item['kalori']?.toStringAsFixed(1)} kkal, ${item['gula']?.toStringAsFixed(1)} g gula',
                        ),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _hapusMakanan(index),
                        ),
                      ),
                      if (index != makananList.length - 1)
                        const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _showPopupDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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

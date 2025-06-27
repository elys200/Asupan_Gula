import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tambahkan import ini
import 'package:sweetsense/pages/jurnal.dart';
import 'jurnal_entry.dart';
import 'jurnal_service.dart';
import 'package:sweetsense/api/openfood_api.dart';
import 'package:sweetsense/api/usda_api.dart';

class PerhitunganGulaPage extends StatefulWidget {
  const PerhitunganGulaPage({super.key});

  @override
  State<PerhitunganGulaPage> createState() => _PerhitunganGulaPageState();
}

class _PerhitunganGulaPageState extends State<PerhitunganGulaPage> {
  String selectedWaktuMakan = 'Makan Siang';
  DateTime selectedDate = DateTime.now();
  final JurnalService _jurnalService = JurnalService();
  bool _isLocaleInitialized = false; // Tambahkan flag untuk tracking inisialisasi

  final List<Map<String, dynamic>> makananList = [
    {
      'nama': 'Telur Rebus',
      'jumlah': '2 sedang',
      'jumlahAngka': 2.0,
      'kalori': 155.0,
      'gula': 1.1,
      'protein': 12.6,
      'lemak': 10.6,
      'karbohidrat': 1.1,
    },
    {
      'nama': 'Salad Sayur',
      'jumlah': '1 mangkok',
      'jumlahAngka': 1.0,
      'kalori': 80.0,
      'gula': 3.5,
      'protein': 2.0,
      'lemak': 0.5,
      'karbohidrat': 15.0,
    },
    {
      'nama': 'Dada ayam',
      'jumlah': '150 gram',
      'jumlahAngka': 1.5,
      'kalori': 165.0,
      'gula': 0.0,
      'protein': 31.0,
      'lemak': 3.6,
      'karbohidrat': 0.0,
    },
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

  // Tambahkan method untuk inisialisasi locale
  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('id_ID', null);
      setState(() {
        _isLocaleInitialized = true;
      });
    } catch (e) {
      print('Error initializing locale: $e');
      // Fallback jika locale id_ID tidak tersedia
      setState(() {
        _isLocaleInitialized = true;
      });
    }
  }

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
    final TextEditingController typeAheadController = TextEditingController();
    final TextEditingController jumlahController = TextEditingController();

    showDialog(
      context: context,
      builder: (contextDialog) {
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
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Jumlah (dalam angka)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialog),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String namaMakanan = typeAheadController.text.trim();
                final String jumlahMakananStr = jumlahController.text.trim();
                final double? jumlahAngka = double.tryParse(jumlahMakananStr);

                if (namaMakanan.isNotEmpty && jumlahAngka != null) {
                  final currentContext = context;
                  Navigator.pop(contextDialog);

                  final hasilOFF =
                      await OpenFoodFactsAPI.fetchNutrisiMakanan(namaMakanan);
                  final hasilUSDA =
                      await USDAApi.fetchNutrisiMakanan(namaMakanan);
                  final hasil = hasilOFF ?? hasilUSDA;

                  if (!mounted) return;

                  setState(() {
                    makananList.add({
                      'nama': namaMakanan,
                      'jumlah': '$jumlahAngka porsi',
                      'jumlahAngka': jumlahAngka,
                      'kalori': hasil?.kalori ?? 0.0,
                      'gula': hasil?.gula ?? 0.0,
                      'protein': hasil?.protein ?? 0.0,
                      'lemak': hasil?.lemak ?? 0.0,
                      'karbohidrat': hasil?.karbohidrat ?? 0.0,
                    });
                  });

                  if (hasil != null) {
                    showDialog(
                      context: currentContext,
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
                            onPressed: () => Navigator.pop(currentContext),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) {
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                          const SnackBar(
                              content: Text('Data nutrisi tidak ditemukan')),
                        );
                      }
                    });
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
                Text('Total Lemak: ${getTotalLemak().toStringAsFixed(1)} gram'),
                Text('Total Karbo: ${getTotalKarbo().toStringAsFixed(1)} gram'),
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
                          _simpanDataJurnal();
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
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

  void _simpanDataJurnal() {
    // Konversi makanan list ke MakananItem
    final List<MakananItem> makananItems = makananList.map((item) {
      return MakananItem(
        nama: item['nama'] ?? '',
        jumlah: item['jumlah'] ?? '',
        jumlahAngka: (item['jumlahAngka'] ?? 0.0).toDouble(),
        kalori: (item['kalori'] ?? 0.0).toDouble(),
        gula: (item['gula'] ?? 0.0).toDouble(),
        protein: (item['protein'] ?? 0.0).toDouble(),
        lemak: (item['lemak'] ?? 0.0).toDouble(),
        karbohidrat: (item['karbohidrat'] ?? 0.0).toDouble(),
      );
    }).toList();

    // Hitung total nutrisi
    final totalKalori = getTotalKalori();
    final totalGula = getTotalGula();
    final totalLemak = getTotalLemak();
    final totalKarbo = getTotalKarbo();

    // Tentukan status berdasarkan total gula
    final status = JurnalService.getStatusFromGula(totalGula);
    final statusColor = JurnalService.getStatusColor(status);

    // Format tanggal dengan safe formatting
    String formattedDate;
    try {
      if (_isLocaleInitialized) {
        formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate);
      } else {
        // Fallback ke format default jika locale belum ready
        formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(selectedDate);
      }
    } catch (e) {
      // Fallback sederhana jika ada error
      formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
    
    final currentTime = DateFormat('HH:mm').format(DateTime.now());

    // Buat jurnal entry baru
    final newEntry = JurnalEntry(
      tanggal: formattedDate,
      waktuMakan: selectedWaktuMakan,
      jam: '$currentTime PM',
      makananList: makananItems,
      totalKalori: totalKalori,
      totalGula: totalGula,
      totalKarbo: totalKarbo,
      totalLemak: totalLemak,
      status: status,
      statusColor: statusColor,
    );

    // Simpan ke service
    _jurnalService.addJurnalEntry(newEntry);

    // Tampilkan snackbar konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil disimpan ke jurnal'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _hapusMakanan(int index) {
    setState(() {
      makananList.removeAt(index);
    });
  }

  double getTotalKalori() {
    return makananList.fold(0.0, (sum, item) {
      double kalori = item['kalori'] ?? 0.0;
      double jumlah = item['jumlahAngka'] ?? 1.0;
      return sum + (kalori * jumlah);
    });
  }

  double getTotalGula() {
    return makananList.fold(0.0, (sum, item) {
      double gula = item['gula'] ?? 0.0;
      double jumlah = item['jumlahAngka'] ?? 1.0;
      return sum + (gula * jumlah);
    });
  }

  double getTotalLemak() {
    return makananList.fold(0.0, (sum, item) {
      double lemak = item['lemak'] ?? 0.0;
      double jumlah = item['jumlahAngka'] ?? 1.0;
      return sum + (lemak * jumlah);
    });
  }

  double getTotalKarbo() {
    return makananList.fold(0.0, (sum, item) {
      double karbo = item['karbohidrat'] ?? 0.0;
      double jumlah = item['jumlahAngka'] ?? 1.0;
      return sum + (karbo * jumlah);
    });
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
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
                        title: Text(item['nama'] ?? ''),
                        subtitle: Text(
                          '${item['jumlah']} - '
                          '${((item['kalori'] ?? 0.0) * (item['jumlahAngka'] ?? 1.0)).toStringAsFixed(1)} kkal, '
                          '${((item['gula'] ?? 0.0) * (item['jumlahAngka'] ?? 1.0)).toStringAsFixed(1)} g gula',
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
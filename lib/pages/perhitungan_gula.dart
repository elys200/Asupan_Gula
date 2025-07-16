import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetsense/models/jurnal_entry.dart';
import 'package:sweetsense/pages/jurnal.dart';
import '../controllers/profile_controller.dart';
import '../services/jurnal_service.dart';
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
  JurnalApiService? _jurnalService;
  bool _isLoadingToken = true;
  int? _userId;

  final profileController = Get.put(ProfileController());

  final List<Map<String, dynamic>> makananList = [];

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

  @override
  void initState() {
    super.initState();
    log('📋 initState dipanggil');
    _initializeLocale().catchError((e, s) {
      logError('❌ Error di _initializeLocale', e, s);
    });
    _loadTokenAndUser().catchError((e, s) {
      logError('❌ Error di _loadTokenAndUser', e, s);
    });
    runZonedGuarded(() {
      log('🔒 Zone guard aktif di halaman ini');
    }, (e, s) {
      logError('🚨 Zone error di halaman ini', e, s);
    });
    profileController.fetchProfile();
  }

  Future<void> _initializeLocale() async {
    log('🌏 Menginisialisasi locale...');
    try {
      await initializeDateFormatting('id_ID', null);
      log('✅ Locale selesai');
    } catch (e, s) {
      logError('❌ Error initializing locale', e, s);
      // Fallback jika locale id_ID tidak tersedia
    }
  }

  Future<void> _loadTokenAndUser() async {
    log('🔑 Loading token & user...');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('user_id');
    log('ℹ️ token: $token, userId: $userId');

    if (token != null && userId != null && mounted) {
      setState(() {
        _jurnalService = JurnalApiService(token: token);
        _userId = userId;
        _isLoadingToken = false;
      });
      log('✅ Token & user loaded');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Token/User ID tidak ditemukan, login lagi')),
      );
      log('❌ Token/User ID tidak ditemukan, kembali');
      Navigator.pop(context);
    }
  }

  void _selectDate() async {
    log('🗓 Memilih tanggal');
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
      log('📅 Tanggal dipilih: $selectedDate');
    }
  }

  void _tambahMakanan() {
    log('🍲 Tambah Makanan dipanggil');
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
                controller: typeAheadController,
                suggestionsCallback: (pattern) {
                  return _makananSuggestions
                      .where((item) =>
                          item.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration:
                        const InputDecoration(labelText: 'Nama Makanan'),
                  );
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion));
                },
                onSelected: (suggestion) {
                  typeAheadController.text = suggestion;
                  log('🍛 Makanan dipilih: $suggestion');
                },
                emptyBuilder: (context) => const Padding(
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
                  log('📥 Makanan: $namaMakanan, Jumlah: $jumlahAngka');

                  dynamic hasil;
                  try {
                    hasil = await OpenFoodFactsAPI.fetchNutrisiMakanan(
                            namaMakanan) ??
                        await USDAApi.fetchNutrisiMakanan(namaMakanan);
                    log('✅ Nutrisi ditemukan untuk $namaMakanan');
                  } catch (e, s) {
                    logError('❌ Gagal fetch nutrisi untuk $namaMakanan', e, s);
                  }

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

  // Popup validasi untuk data makanan kosong
  void _showEmptyDataDialog() {
    log('⚠️ Popup validasi data kosong muncul');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Text('Perhatian!'),
            ],
          ),
          content: const Text(
            'Anda belum menambahkan makanan apapun. Silakan tambahkan makanan terlebih dahulu untuk melakukan perhitungan.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _tambahMakanan(); // Langsung buka dialog tambah makanan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Tambah Makanan'),
            ),
          ],
        );
      },
    );
  }

  void _showPopupDialog() {
    log('📋 Konfirmasi simpan muncul');
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
                          Navigator.of(context).pop();
                          _simpanDataJurnal();
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

  // Method untuk handle tombol hitung dengan validasi
  void _handleHitungButton() {
    log('🧮 Tombol hitung ditekan');
    
    // Validasi apakah makananList kosong
    if (makananList.isEmpty) {
      log('⚠️ Tidak ada data makanan, tampilkan popup validasi');
      _showEmptyDataDialog();
      return;
    }
    
    // Jika ada data makanan, lanjutkan ke popup konfirmasi
    log('✅ Ada data makanan, lanjut ke popup konfirmasi');
    _showPopupDialog();
  }

  Future<void> _simpanDataJurnal() async {
    log('💾 Menyimpan data jurnal...');
    if (_jurnalService == null || _userId == null) {
      log('❌ JurnalService/userId null');
      return;
    }

    final tanggal = DateFormat('yyyy-MM-dd').format(selectedDate);
    final waktuMakan = selectedWaktuMakan;
    final totalGula = getTotalGula();
    final totalKalori = getTotalKalori();
    final totalKarbo = getTotalKarbo();
    final totalLemak = getTotalLemak();

    final jamSekarang = DateFormat('HH:mm').format(DateTime.now());

    log('📦 Kirim ke backend: tanggal=$tanggal, waktu_makan=$waktuMakan, total_gula=$totalGula, total_kalori=$totalKalori, total_karbo=$totalKarbo, total_lemak=$totalLemak, jam=$jamSekarang');

    try {
      final entry = JurnalEntry(
        id: 0,
        tanggal: tanggal,
        waktuMakan: waktuMakan,
        totalGula: totalGula,
        kategori: null,
        jam: jamSekarang,
        totalKalori: totalKalori,
        totalKarbo: totalKarbo,
        totalLemak: totalLemak,
        status: null,
        statusColor: null,
      );
      await _jurnalService!.tambahJurnal(entry, _userId!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
      log('✅ Data jurnal tersimpan');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const JurnalPage()));
    } catch (e, s) {
      logError('❌ Gagal simpan jurnal', e, s);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal simpan: $e')));
    }
  }

  void _hapusMakanan(int index) {
    log('🗑 Hapus makanan di index: $index');
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

  // Widget helper untuk avatar placeholder
  Widget _buildAvatarPlaceholder({double radius = 20}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: radius, color: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    log('📋 build dipanggil, _isLoadingToken=$_isLoadingToken');
    if (_isLoadingToken) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        title: Text(
          'Perhitungan Gula Darah',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Color(0xFFE43A15),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE43A15), Color(0xFFE65245)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(() {
              final user = profileController.user.value;
              return user?.fotoUrl != null && user!.fotoUrl!.isNotEmpty
                  ? CircleAvatar(
                      radius: 20,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user.fotoUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                            ),
                          ),
                          errorWidget: (context, url, error) => _buildAvatarPlaceholder(radius: 20),
                        ),
                      ),
                    )
                  : _buildAvatarPlaceholder(radius: 20);
            }),
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
              children: [
                Obx(() {
                  final user = profileController.user.value;
                  return user?.fotoUrl != null && user!.fotoUrl!.isNotEmpty
                      ? CircleAvatar(
                          radius: 20,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: user.fotoUrl!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) => _buildAvatarPlaceholder(),
                            ),
                          ),
                        )
                      : _buildAvatarPlaceholder();
                }),
                const SizedBox(width: 10),
                const Expanded(
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
                      log('🍽 Waktu makan dipilih: $selectedWaktuMakan');
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
                onPressed: _handleHitungButton, // Menggunakan method baru dengan validasi
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

  void log(String message) {
    print(message);
  }

  void logError(String context, Object error, StackTrace? stack) {
    // ignore: avoid_print
    print('$context: $error');
    if (stack != null) {
      // ignore: avoid_print
      print(stack);
    }
  }
}
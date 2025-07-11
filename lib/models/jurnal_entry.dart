class JurnalEntry {
  final int id;
  final String tanggal;
  final String waktuMakan;
  final double totalGula;
  final String? kategori;
  final String? jam;
  final double? totalKalori;
  final double? totalKarbo;
  final double? totalLemak;
  final String? status;
  final String? statusColor;
  final List<MakananItem> makananList;

  JurnalEntry({
    required this.id,
    required this.tanggal,
    required this.waktuMakan,
    required this.totalGula,
    this.kategori,
    this.jam,
    this.totalKalori,
    this.totalKarbo,
    this.totalLemak,
    this.status,
    this.statusColor,
    this.makananList = const [],
  });

  factory JurnalEntry.fromMap(Map<String, dynamic> map) {
    return JurnalEntry(
      id: map['id'] ?? 0,
      tanggal: map['date'] ?? '',
      waktuMakan: map['waktu_makan'] ?? '',
      totalGula: _toDouble(map['total_gula']),
      kategori: map['kategori']?['nama'],
      jam: map['jam'],
      totalKalori: _toDouble(map['total_kalori']),
      totalKarbo: _toDouble(map['total_karbo']),
      totalLemak: _toDouble(map['total_lemak']),
      status: map['status'],
      statusColor: map['status_color'],
      makananList: (map['makanan_list'] as List<dynamic>?)
              ?.map((e) => MakananItem.fromMap(e))
              .toList() ??
          [],
    );
  }

  /// payload untuk Laravel
  Map<String, dynamic> toLaravelPayload(int userId) {
    return {
      'user_id': userId,
      'waktu_makan': waktuMakan,
      'total_gula': totalGula,
      'date': tanggal,
      'jam': jam,
      'total_kalori': totalKalori,
      'total_karbo': totalKarbo,
      'total_lemak': totalLemak,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class MakananItem {
  final String nama;
  final String jumlah;
  final double jumlahAngka;
  final double kalori;
  final double gula;
  final double protein;
  final double lemak;
  final double karbohidrat;

  MakananItem({
    required this.nama,
    required this.jumlah,
    required this.jumlahAngka,
    required this.kalori,
    required this.gula,
    this.protein = 0.0,
    this.lemak = 0.0,
    this.karbohidrat = 0.0,
  });

  factory MakananItem.fromMap(Map<String, dynamic> map) {
    return MakananItem(
      nama: map['nama'] ?? '',
      jumlah: map['jumlah'] ?? '',
      jumlahAngka: JurnalEntry._toDouble(map['jumlahAngka']),
      kalori: JurnalEntry._toDouble(map['kalori']),
      gula: JurnalEntry._toDouble(map['gula']),
      protein: JurnalEntry._toDouble(map['protein']),
      lemak: JurnalEntry._toDouble(map['lemak']),
      karbohidrat: JurnalEntry._toDouble(map['karbohidrat']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jumlah': jumlah,
      'jumlahAngka': jumlahAngka,
      'kalori': kalori,
      'gula': gula,
      'protein': protein,
      'lemak': lemak,
      'karbohidrat': karbohidrat,
    };
  }
}

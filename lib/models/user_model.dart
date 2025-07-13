import 'package:sweetsense/constants/constants.dart';

class UserModel {
  final int id;
  final String username;
  final String email;
  final int umur;
  final double beratBadan;
  final String jenisKelamin;
  final String? foto;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.umur,
    required this.beratBadan,
    required this.jenisKelamin,
    this.foto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      umur: int.tryParse(json['umur'].toString()) ?? 0,
      beratBadan: double.parse(json['berat_badan'].toString()),
      jenisKelamin: json['jenis_kelamin'],
      foto: json['foto'],
    );
  }
  String? get fotoUrl {
    if (foto == null || foto!.isEmpty) return null;
    if (foto!.startsWith('http')) return foto;
    return '${url.replaceFirst('/api/', '/storage/')}$foto';
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    int? umur,
    double? beratBadan,
    String? jenisKelamin,
    String? foto,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      umur: umur ?? this.umur,
      beratBadan: beratBadan ?? this.beratBadan,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      foto: foto,
    );
  }
}

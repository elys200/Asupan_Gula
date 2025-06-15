import 'food_model.dart';

class FavoriteRecipeModel {
  final int? id;
  final int userId;
  final int resepId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FoodModel? resep;

  FavoriteRecipeModel({
    this.id,
    required this.userId,
    required this.resepId,
    required this.createdAt,
    required this.updatedAt,
    this.resep,
  });

  factory FavoriteRecipeModel.fromJson(Map<String, dynamic> json) {
    return FavoriteRecipeModel(
      id: json['id'],
      userId: json['user_id'],
      resepId: json['resep_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      resep: json['resep'] != null ? FoodModel.fromJson(json['resep']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'resep_id': resepId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (resep != null) 'resep': resep!.toJson(),
    };
  }
}

import 'package:gompa_tour/models/statue_translation.dart';

class Statue {
  final String id;
  final String image;
  final List<StatueTranslation> translations;
  final DateTime createdAt;
  final DateTime updatedAt;

  Statue({
    required this.id,
    required this.image,
    this.translations = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Statue.fromJson(Map<String, dynamic> json) => Statue(
        id: json['id'],
        image: json['image'],
        translations: (json['translations'] as List?)
                ?.map((e) => StatueTranslation.fromJson(e))
                .toList() ??
            [],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

import 'package:gompa_tour/models/festival_translation.dart';

class Festival {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String? image;
  final List<FestivalTranslation> translations;
  final DateTime? createdAt;
  final DateTime updatedAt;

  Festival({
    required this.id,
    required this.startDate,
    required this.endDate,
    this.image,
    this.translations = const [],
    this.createdAt,
    required this.updatedAt,
  });

  factory Festival.fromJson(Map<String, dynamic> json) => Festival(
        id: json['id'],
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date']),
        image: json['image'],
        translations: (json['translations'] as List?)
                ?.map((e) => FestivalTranslation.fromJson(e))
                .toList() ??
            [],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'image': image,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

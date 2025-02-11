import 'package:gompa_tour/models/gonpa_translation.dart';

enum Sect { NYINGMA, KAGYU, SAKYA, GELUG, BHON, OTHER }

enum GonpaType { MONASTERY, NUNNERY, TEMPLE, NGAKPA, OTHER }

class Gonpa {
  final String id;
  final String image;
  final String geoLocation;
  final Sect sect;
  final GonpaType type;
  final String? contactId;
  final List<GonpaTranslation> translations;
  final DateTime createdAt;
  final DateTime updatedAt;

  Gonpa({
    required this.id,
    required this.image,
    required this.geoLocation,
    required this.sect,
    required this.type,
    this.contactId,
    this.translations = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Gonpa.fromJson(Map<String, dynamic> json) => Gonpa(
        id: json['id'],
        image: json['image'],
        geoLocation: json['geo_location'],
        sect: Sect.values
            .firstWhere((e) => e.toString() == 'Sect.${json['sect']}'),
        type: GonpaType.values
            .firstWhere((e) => e.toString() == 'GonpaType.${json['type']}'),
        contactId: json['contactId'],
        translations: (json['translations'] as List?)
                ?.map((e) => GonpaTranslation.fromJson(e))
                .toList() ??
            [],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'geo_location': geoLocation,
        'sect': sect.toString().split('.').last,
        'type': type.toString().split('.').last,
        'contactId': contactId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

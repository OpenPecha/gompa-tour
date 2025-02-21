import 'package:gompa_tour/models/contact.dart';
import 'package:gompa_tour/models/pilgrim_site_translation.dart';

class PilgrimSite {
  final String id;
  final String image;
  final String geoLocation;
  final Contact? contact;
  final String? contactId;
  final List<PilgrimSiteTranslation> translations;
  final DateTime createdAt;
  final DateTime updatedAt;

  PilgrimSite({
    required this.id,
    required this.image,
    required this.geoLocation,
    this.contact,
    this.contactId,
    this.translations = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory PilgrimSite.fromJson(Map<String, dynamic> json) => PilgrimSite(
        id: json['id'],
        image: json['image'],
        geoLocation: json['geo_location'],
        contact:
            json['contact'] != null ? Contact.fromJson(json['contact']) : null,
        contactId: json['contactId'],
        translations: (json['translations'] as List?)
                ?.map((e) => PilgrimSiteTranslation.fromJson(e))
                .toList() ??
            [],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'geo_location': geoLocation,
        'contactId': contactId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

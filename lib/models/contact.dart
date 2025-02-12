import 'package:gompa_tour/models/contact_translation.dart';

class Contact {
  final String id;
  final String email;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ContactTranslation> translations;

  Contact({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    this.translations = const [],
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json['id'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        translations: (json['translations'] as List?)
                ?.map((e) => ContactTranslation.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone_number': phoneNumber,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

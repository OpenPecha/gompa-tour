class GonpaTranslation {
  final String id;
  final String gonpaId;
  final String languageCode;
  final String name;
  final String description;
  final String descriptionAudio;

  GonpaTranslation({
    required this.id,
    required this.gonpaId,
    required this.languageCode,
    required this.name,
    required this.description,
    required this.descriptionAudio,
  });

  factory GonpaTranslation.fromJson(Map<String, dynamic> json) =>
      GonpaTranslation(
        id: json['id'],
        gonpaId: json['gonpaId'],
        languageCode: json['languageCode'],
        name: json['name'],
        description: json['description'],
        descriptionAudio: json['description_audio'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gonpaId': gonpaId,
        'languageCode': languageCode,
        'name': name,
        'description': description,
        'description_audio': descriptionAudio,
      };
}

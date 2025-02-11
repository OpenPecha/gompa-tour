class StatueTranslation {
  final String languageCode;
  final String name;
  final String description;
  final String descriptionAudio;

  StatueTranslation({
    required this.languageCode,
    required this.name,
    required this.description,
    required this.descriptionAudio,
  });

  factory StatueTranslation.fromJson(Map<String, dynamic> json) =>
      StatueTranslation(
        languageCode: json['languageCode'],
        name: json['name'],
        description: json['description'],
        descriptionAudio: json['description_audio'],
      );

  Map<String, dynamic> toJson() => {
        'languageCode': languageCode,
        'name': name,
        'description': description,
        'description_audio': descriptionAudio,
      };
}

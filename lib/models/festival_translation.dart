class FestivalTranslation {
  final String id;
  final String festivalId;
  final String languageCode;
  final String name;
  final String description;
  final String descriptionAudio;

  FestivalTranslation({
    required this.id,
    required this.festivalId,
    required this.languageCode,
    required this.name,
    required this.description,
    required this.descriptionAudio,
  });

  factory FestivalTranslation.fromJson(Map<String, dynamic> json) =>
      FestivalTranslation(
        id: json['id'],
        festivalId: json['festivalId'],
        languageCode: json['languageCode'],
        name: json['name'],
        description: json['description'],
        descriptionAudio: json['description_audio'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'festivalId': festivalId,
        'languageCode': languageCode,
        'name': name,
        'description': description,
        'description_audio': descriptionAudio,
      };
}

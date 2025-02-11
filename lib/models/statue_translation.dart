class StatueTranslation {
  final String id;
  final String statueId;
  final String languageCode;
  final String name;
  final String description;
  final String descriptionAudio;

  StatueTranslation({
    required this.id,
    required this.statueId,
    required this.languageCode,
    required this.name,
    required this.description,
    required this.descriptionAudio,
  });

  factory StatueTranslation.fromJson(Map<String, dynamic> json) =>
      StatueTranslation(
        id: json['id'],
        statueId: json['statueId'],
        languageCode: json['languageCode'],
        name: json['name'],
        description: json['description'],
        descriptionAudio: json['description_audio'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'statueId': statueId,
        'languageCode': languageCode,
        'name': name,
        'description': description,
        'description_audio': descriptionAudio,
      };
}

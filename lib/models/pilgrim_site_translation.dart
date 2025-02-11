class PilgrimSiteTranslation {
  final String id;
  final String pilgrimSiteId;
  final String languageCode;
  final String name;
  final String description;
  final String descriptionAudio;

  PilgrimSiteTranslation({
    required this.id,
    required this.pilgrimSiteId,
    required this.languageCode,
    required this.name,
    required this.description,
    required this.descriptionAudio,
  });

  factory PilgrimSiteTranslation.fromJson(Map<String, dynamic> json) =>
      PilgrimSiteTranslation(
        id: json['id'],
        pilgrimSiteId: json['pilgrimSiteId'],
        languageCode: json['languageCode'],
        name: json['name'],
        description: json['description'],
        descriptionAudio: json['description_audio'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'pilgrimSiteId': pilgrimSiteId,
        'languageCode': languageCode,
        'name': name,
        'description': description,
        'description_audio': descriptionAudio,
      };
}

class Pligrimage {
  final int id;
  final String image;
  final String geoLocation;
  final String? enName;
  final String? boName;
  final String? enDescription;
  final String? boDescription;
  final String? contact;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pligrimage({
    required this.id,
    required this.image,
    required this.geoLocation,
    this.enName,
    this.boName,
    this.enDescription,
    this.boDescription,
    this.contact,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pligrimage.fromMap(Map<String, dynamic> map) {
    return Pligrimage(
      id: map['id'] as int,
      image: map['image'] as String,
      geoLocation: map['geo_location'] as String,
      enName: map['en_name'] as String?,
      boName: map['bo_name'] as String?,
      enDescription: map['en_description'] as String?,
      boDescription: map['bo_description'] as String?,
      contact: map['contact'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'geo_location': geoLocation,
      'en_name': enName,
      'bo_name': boName,
      'en_description': enDescription,
      'bo_description': boDescription,
      'contact': contact,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Pilgrimage {
  final int id;
  final String image;
  final String geoLocation;
  final String? enName;
  final String? boName;
  final String? enDescription;
  final String? boDescription;
  final String address;
  final String state;
  final String country;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pilgrimage({
    required this.id,
    required this.image,
    required this.geoLocation,
    this.enName,
    this.boName,
    this.enDescription,
    this.boDescription,
    required this.address,
    required this.state,
    required this.country,
    this.createdAt,
    this.updatedAt,
  });

  factory Pilgrimage.fromMap(Map<String, dynamic> map) {
    return Pilgrimage(
      id: map['id'] as int,
      image: map['image'] as String,
      geoLocation: map['geo_location'] as String,
      enName: map['en_name'] as String?,
      boName: map['bo_name'] as String?,
      enDescription: map['en_description'] as String?,
      boDescription: map['bo_description'] as String?,
      address: map['address'] as String,
      state: map['state'] as String,
      country: map['country'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
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
      'address': address,
      'state': state,
      'country': country,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

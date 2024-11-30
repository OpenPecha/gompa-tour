class Festival {
  final int id;
  final int uid;
  final String? eventTbName;
  final String? eventEnName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? tbDescription;
  final String? enDescription;
  final String? categories;
  final String? location;
  final String pic;
  final String status;
  final String? slug;
  final DateTime created;
  final DateTime updated;

  Festival({
    required this.id,
    required this.uid,
    this.eventTbName,
    this.eventEnName,
    this.startDate,
    this.endDate,
    this.tbDescription,
    this.enDescription,
    this.categories,
    this.location,
    required this.pic,
    required this.status,
    this.slug,
    required this.created,
    required this.updated,
  });

  factory Festival.fromMap(Map<String, dynamic> map) {
    return Festival(
      id: map['id'] as int,
      uid: map['uid'] as int,
      eventTbName: map['event_tbname'] as String?,
      eventEnName: map['event_enname'] as String?,
      startDate: map['start_date'] != null
          ? DateTime.parse(map['start_date'] as String)
          : null,
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'] as String)
          : null,
      tbDescription: map['tb_description'] as String?,
      enDescription: map['en_description'] as String?,
      categories: map['categories'] as String?,
      location: map['location'] as String?,
      pic: map['pic'] as String,
      status: map['status'] as String,
      slug: map['slug'] as String?,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'event_tbname': eventTbName,
      'event_enname': eventEnName,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'tb_description': tbDescription,
      'en_description': enDescription,
      'categories': categories,
      'location': location,
      'pic': pic,
      'status': status,
      'slug': slug,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  Festival copyWith({
    int? id,
    int? uid,
    String? eventTbName,
    String? eventEnName,
    DateTime? startDate,
    DateTime? endDate,
    String? tbDescription,
    String? enDescription,
    String? categories,
    String? location,
    String? pic,
    String? status,
    String? slug,
    DateTime? created,
    DateTime? updated,
  }) {
    return Festival(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      eventTbName: eventTbName ?? this.eventTbName,
      eventEnName: eventEnName ?? this.eventEnName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      tbDescription: tbDescription ?? this.tbDescription,
      enDescription: enDescription ?? this.enDescription,
      categories: categories ?? this.categories,
      location: location ?? this.location,
      pic: pic ?? this.pic,
      status: status ?? this.status,
      slug: slug ?? this.slug,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }
}

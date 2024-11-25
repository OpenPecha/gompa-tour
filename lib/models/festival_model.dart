class Festival {
  final int id;
  final int uid;
  final String? tbTitle;
  final String? enTitle;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? tbContent;
  final String? enContent;
  final String categories;
  final String? location;
  final String pic;
  final String status;
  final String? slug;
  final DateTime created;
  final DateTime updated;

  Festival({
    required this.id,
    required this.uid,
    this.tbTitle,
    this.enTitle,
    this.startDate,
    this.endDate,
    this.tbContent,
    this.enContent,
    required this.categories,
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
      tbTitle: map['tbtitle'] as String?,
      enTitle: map['entitle'] as String?,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      tbContent: map['tbcontent'] as String?,
      enContent: map['encontent'] as String?,
      categories: map['categories'] as String,
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
      'tbtitle': tbTitle,
      'entitle': enTitle,
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
      'tbcontent': tbContent,
      'encontent': enContent,
      'categories': categories,
      'location': location,
      'pic': pic,
      'status': status,
      'slug': slug,
      'created': created.toString(),
      'updated': updated.toString(),
    };
  }

  Festival copyWith({
    int? id,
    int? uid,
    String? tbTitle,
    String? enTitle,
    DateTime? startDate,
    DateTime? endDate,
    String? tbContent,
    String? enContent,
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
      tbTitle: tbTitle ?? this.tbTitle,
      enTitle: enTitle ?? this.enTitle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      tbContent: tbContent ?? this.tbContent,
      enContent: enContent ?? this.enContent,
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

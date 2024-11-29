class Deity {
  final int id;
  final int uid;
  final String tbTitle;
  final String enTitle;
  final String tbContent;
  final String enContent;
  final String? status;
  final String? callNumber;
  final String? slug;
  final String? pic;
  final String? sound;

  final DateTime created;
  final DateTime updated;

  Deity({
    required this.id,
    required this.uid,
    required this.tbTitle,
    required this.enTitle,
    required this.tbContent,
    required this.enContent,
    this.status,
    this.callNumber,
    this.slug,
    this.pic,
    this.sound,
    required this.created,
    required this.updated,
  });

  factory Deity.fromMap(Map<String, dynamic> map) {
    return Deity(
      id: map['id'] as int,
      uid: map['uid'] as int,
      tbTitle: map['tbtitle'] as String,
      enTitle: map['entitle'] as String,
      tbContent: map['tbcontent'] as String,
      enContent: map['encontent'] as String,
      status: map['status'] as String?,
      callNumber: map['callnumber'] as String?,
      slug: map['slug'] as String?,
      pic: map['pic'] as String?,
      sound: map['sound'] as String?,
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
      'tbcontent': tbContent,
      'encontent': enContent,
      'status': status,
      'callnumber': callNumber,
      'slug': slug,
      'pic': pic,
      'sound': sound,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  Deity copyWith({
    int? id,
    int? uid,
    String? tbTitle,
    String? enTitle,
    String? tbContent,
    String? enContent,
    String? status,
    String? callNumber,
    String? slug,
    String? pic,
    String? sound,
    DateTime? created,
    DateTime? updated,
  }) {
    return Deity(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      tbTitle: tbTitle ?? this.tbTitle,
      enTitle: enTitle ?? this.enTitle,
      tbContent: tbContent ?? this.tbContent,
      enContent: enContent ?? this.enContent,
      status: status ?? this.status,
      callNumber: callNumber ?? this.callNumber,
      slug: slug ?? this.slug,
      pic: pic ?? this.pic,
      sound: sound ?? this.sound,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }
}

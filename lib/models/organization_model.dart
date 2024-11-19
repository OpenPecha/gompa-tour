class Organization {
  final int? id;
  final int uid;
  final String tbTitle;
  final String enTitle;
  final String tbContent;
  final String enContent;
  final String? categories;
  final String street;
  final String address2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String phone;
  final String email;
  final String web;
  final String map;
  final String status;
  final String callNumber;
  final String slug;
  final String pic;
  final String? sound;
  final DateTime created;
  final DateTime updated;

  Organization({
    this.id,
    required this.uid,
    required this.tbTitle,
    required this.enTitle,
    required this.tbContent,
    required this.enContent,
    this.categories,
    required this.street,
    required this.address2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phone,
    required this.email,
    required this.web,
    required this.map,
    required this.status,
    required this.callNumber,
    required this.slug,
    required this.pic,
    this.sound,
    required this.created,
    required this.updated,
  });

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      id: map['id'] as int?,
      uid: map['uid'] as int,
      tbTitle: map['tbtitle'] as String,
      enTitle: map['entitle'] as String,
      tbContent: map['tbcontent'] as String,
      enContent: map['encontent'] as String,
      categories: map['categories'] as String?,
      street: map['street'] as String,
      address2: map['address_2'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      postalCode: map['postal_code'] as String,
      country: map['country'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      web: map['web'] as String,
      map: map['map'] as String,
      status: map['status'] as String,
      callNumber: map['callnumber'] as String,
      slug: map['slug'] as String,
      pic: map['pic'] as String,
      sound: map['sound'] as String?,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'tbtitle': tbTitle,
      'entitle': enTitle,
      'tbcontent': tbContent,
      'encontent': enContent,
      'categories': categories,
      'street': street,
      'address_2': address2,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'phone': phone,
      'email': email,
      'web': web,
      'map': map,
      'status': status,
      'callnumber': callNumber,
      'slug': slug,
      'pic': pic,
      'sound': sound,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  // Optional: Add copyWith method for easy updates
  Organization copyWith({
    int? id,
    int? uid,
    String? tbTitle,
    String? enTitle,
    String? tbContent,
    String? enContent,
    String? categories,
    String? street,
    String? address2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phone,
    String? email,
    String? web,
    String? map,
    String? status,
    String? callNumber,
    String? slug,
    String? pic,
    String? sound,
    DateTime? created,
    DateTime? updated,
  }) {
    return Organization(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      tbTitle: tbTitle ?? this.tbTitle,
      enTitle: enTitle ?? this.enTitle,
      tbContent: tbContent ?? this.tbContent,
      enContent: enContent ?? this.enContent,
      categories: categories ?? this.categories,
      street: street ?? this.street,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      web: web ?? this.web,
      map: map ?? this.map,
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

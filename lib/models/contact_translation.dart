class ContactTranslation {
  final String id;
  final String contactId;
  final String languageCode;
  final String address;
  final String city;
  final String state;
  final String? postalCode;
  final String country;

  ContactTranslation({
    required this.id,
    required this.contactId,
    required this.languageCode,
    required this.address,
    required this.city,
    required this.state,
    this.postalCode,
    required this.country,
  });

  factory ContactTranslation.fromJson(Map<String, dynamic> json) =>
      ContactTranslation(
        id: json['id'],
        contactId: json['contactId'],
        languageCode: json['languageCode'],
        address: json['address'],
        city: json['city'],
        state: json['state'],
        postalCode: json['postal_code'],
        country: json['country'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'contactId': contactId,
        'languageCode': languageCode,
        'address': address,
        'city': city,
        'state': state,
        'postal_code': postalCode,
        'country': country,
      };
}

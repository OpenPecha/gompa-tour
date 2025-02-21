enum QrType { statue, gonpa, festival, site }

class QrCodeValidator {
  final String? error;
  final QrType? type;
  final String? idValue;

  QrCodeValidator({this.error, this.type, this.idValue});

  bool get isValid => error == null;
}

// URL validation and processing
QrCodeValidator extractQrAndValidate(String url) {
  try {
    Uri? uri = Uri.tryParse(url);

    if (uri == null || uri.host != 'neykorweb.onrender.com') {
      return QrCodeValidator(
          error: 'Invalid URL. The domain must be neykorweb.onrender.com');
    }

    List<String> path = uri.pathSegments.isNotEmpty ? uri.pathSegments : [];

    QrType? type;
    if (path.any((element) => element == 'Statue')) {
      type = QrType.statue;
    } else if (path.any((element) => element == 'Monastary')) {
      type = QrType.gonpa;
    } else if (path.any((element) => element == 'Festival')) {
      type = QrType.festival;
    } else if (path.any((element) => element == 'Sacred')) {
      type = QrType.site;
    } else {
      return QrCodeValidator(
          error:
              'Invalid URL path. The path must be Statue, Monastary, Festival or Sacred');
    }

    final idValue = uri.pathSegments.last;

    if (idValue.isEmpty) {
      return QrCodeValidator(error: 'Invalid URL. ID value is missing');
    }

    return QrCodeValidator(type: type, idValue: idValue);
  } catch (e) {
    return QrCodeValidator(error: 'Something went wrong. Please try again.');
  }
}

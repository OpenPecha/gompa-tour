enum QrType { tensum, organization }

class QrCodeValidator {
  final String? error;
  final QrType? type;
  final String? urlValue;

  QrCodeValidator({this.error, this.type, this.urlValue});

  bool get isValid => error == null;
}

// URL validation and processing
QrCodeValidator extractQrAndValidate(String url) {
  try {
    Uri? uri = Uri.tryParse(url);

    if (uri == null || uri.host != 'gompatour.com') {
      return QrCodeValidator(
          error: 'Invalid URL. The domain must be gompatour.com');
    }

    String path = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';

    QrType? type;
    if (path == 'tensum.php') {
      type = QrType.tensum;
    } else if (path == 'organization.php') {
      type = QrType.organization;
    } else {
      return QrCodeValidator(
          error: 'Invalid URL path. Must be tensum or organization');
    }

    final queryParams = uri.queryParameters;
    final urlValue = queryParams['url'];

    if (urlValue == null) {
      return QrCodeValidator(error: 'URL parameter is missing');
    }

    return QrCodeValidator(type: type, urlValue: urlValue);
  } catch (e) {
    return QrCodeValidator(error: 'Something went wrong. Please try again.');
  }
}

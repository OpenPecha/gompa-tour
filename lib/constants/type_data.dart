class TypeData {

  static const Map<String, String> typeTranslations = {
    "MONASTERY": "དགོན་པ།",
    "NUNNERY": "བཙུན་དགོན།",
    "TEMPLE": "ལྷ་ཁང་།",
  };

  static String getLocalizedTypeName(
      String type, String languageCode) {
    final typeUpper = type.toUpperCase();
    return languageCode == 'bo'
        ? typeTranslations[typeUpper] ?? typeUpper
        : typeUpper;
  }
}

class TranslationHelper {
  static String getTranslatedField<T>({
    required List<T> translations,
    required String languageCode,
    required String Function(T) fieldGetter,
  }) {
    try {
      final translation = translations.firstWhere(
        (t) => (t as dynamic).languageCode == languageCode,
        orElse: () => translations.first,
      );
      return fieldGetter(translation);
    } catch (e) {
      return '';
    }
  }
}

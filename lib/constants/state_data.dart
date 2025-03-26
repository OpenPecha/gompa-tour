/// Contains mapping of state names between English and Tibetan
class StateData {
  /// Map of state names with English (uppercase) as keys and Tibetan as values
  static const Map<String, String> stateTranslationsForGonpa = {
    "ARUNACHAL PRADESH": "ཨ་རུ་ཎཱ་ཅལ།",
    "BIHAR": "བི་ཧཱར།",
    "CHHATTISGARH": "ཆ་ཏྟཱིས་གར།",
    "DELHI": "ལྡི་ལི།",
    "HIMACHAL PRADESH": "ཧི་མཱ་ཅལ།",
    "KARNATAKA": "ཀརནཱ་ཊཀ།",
    "LADAKH": "ལ་དྭགས།",
    "MEGHALAYA": "མེ་གྷཱ་ལ་ཡ།",
    "MADHYA PRADESH": "མདྱ། པྲདེཤ",
    "MAHARASHTRA": "མཧཱ་རཥཊྲ།",
    "ODISHA": "ཨོ་ཌི་ཤཱ།",
    "SIKKIM": "སིག་ཀྱིམ།",
    "UTTAR PRADESH": "ཨུ་ཏར་པར་དྷི་ཤི།",
    "UTTARAKHAND": "ཨུ་ཏར་ཁན།",
    "WEST BENGAL": "ཝི་ས་གྷན་གོལ།",
    "KATHMANDU": "ཀ་ཐ་མན་གྲུ།",
    "LUMBINI": "ལུམ་བི་ཎི།",
    "POKHARA": "སྤོག་ར།",
    "SOLOKHUMBU": "སོ་ལོ་ཁམ་བུ།",
  };

  /// Map of state names with English (uppercase) as keys and Tibetan as values for Pilgrimage
  static const Map<String, String> stateTranslationForPilgrim = {
    "ANDHRA PRADESH": "ཨན་དྷ་ར་པྲདེ་ཤ།",
    "ARUNACHAL PRADESH": "ཨ་རུ་ཎཱ་ཅལ།",
    "BIHAR": "བི་ཧཱར།",
    "DELHI": "ལྡི་ལི།",
    "HIMACHAL PRADESH": "ཧི་མཱ་ཅལ།",
    "MADHYA PRADESH": "མདྱ། པྲདེཤ",
    "MAHARASHTRA": "མཧཱ་རཥཊྲ།",
    "UTTAR PRADESH": "ཨུ་ཏར་པར་དྷི་ཤི།",
    "UTTARAKHAND": "ཨུ་ཏར་ཁན།",
    "LUMBINI": "ལུམ་བི་ཎི།",
  };

  /// Get the localized state name based on the current locale
  static String getLocalizedStateNameForGonpa(
      String state, String languageCode) {
    final stateUpper = state.toUpperCase();
    return languageCode == 'bo'
        ? stateTranslationsForGonpa[stateUpper] ?? stateUpper
        : stateUpper;
  }

  // Get the localized state name based on the current locale for Pilgrimage
  static String getLocalizedStateNameForPilgrim(
      String state, String languageCode) {
    final stateUpper = state.toUpperCase();
    return languageCode == 'bo'
        ? stateTranslationForPilgrim[stateUpper] ?? stateUpper
        : stateUpper;
  }
}

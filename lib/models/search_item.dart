enum SearchType { organization, deity }

abstract class SearchableItem {
  final int id;
  final String? pic;
  final String? sound;
  final String enTitle;
  final String enContent;
  final String tbTitle;
  final String tbContent;
  final SearchType type;

  const SearchableItem({
    required this.id,
    this.pic,
    this.sound,
    required this.enTitle,
    required this.enContent,
    required this.tbTitle,
    required this.tbContent,
    required this.type,
  });

  Map<String, dynamic> toMap();
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/deties_state.dart';
import '../../states/recent_search.dart';
import '../../util/search_debouncer.dart';
import '../widget/deity_card_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();

  // Suggestion categories
  final List<Map<String, IconData>> _suggestions = [
    {'Acharya': Icons.house},
    {'Buddha': Icons.temple_buddhist},
    {'Gaden': Icons.temple_hindu},
    {'Arya': Icons.account_balance},
    {'King': Icons.account_balance_wallet},
    {'Milarepa': Icons.account_balance_wallet},
  ]..shuffle();

  @override
  void initState() {
    super.initState();
    // Automatically open keyboard when screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty || query.length < 3) {
      _clearSearchResults();
      return;
    }

    _searchDebouncer.run(
      query,
      onSearch: (q) =>
          ref.read(detiesNotifierProvider.notifier).searchDeities(q),
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: _clearSearchResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(detiesNotifierProvider);
    final recentSearches = ref.watch(recentSearchesProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _clearSearchResults();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _performSearch(value);
              },
            ),
          ),
          if (searchResults.isEmpty) ...[
            // Recent Searches Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            recentSearches.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Text('No recent searches')),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: recentSearches
                          .map((search) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: RawChip(
                                  label: Text(search),
                                  onDeleted: () {
                                    ref
                                        .read(recentSearchesProvider.notifier)
                                        .removeSearch(search);
                                  },
                                  onPressed: () {
                                    _searchController.text = search;
                                    _performSearch(search);
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
            // Suggestions Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Suggestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = suggestion.keys.first;
                      _performSearch(suggestion.keys.first);
                    },
                    child: Card(
                      shadowColor: Theme.of(context).colorScheme.shadow,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(suggestion.values.first, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            suggestion.keys.first,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Search Results Section
          ] else ...[
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final deity = searchResults[index];
                  return DeityCardItem(deity: deity);
                },
              ),
            )
          ]
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  void _clearSearchResults() {
    ref.read(detiesNotifierProvider.notifier).clearSearchResults();
  }
}

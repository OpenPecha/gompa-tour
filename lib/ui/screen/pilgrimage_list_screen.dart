import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/pilgrimage_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/pilgrimage_card_item.dart';
import 'package:gompa_tour/util/search_debouncer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ViewType { grid, list }

class PilgrimageListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/pilgrimage-list';
  const PilgrimageListScreen({super.key});

  @override
  ConsumerState<PilgrimageListScreen> createState() =>
      _PilgrimageListScreenState();
}

class _PilgrimageListScreenState extends ConsumerState<PilgrimageListScreen> {
  late PilgrimageNotifier pilgrimageNotifier;
  ViewType _currentView = ViewType.list;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();

  @override
  void initState() {
    super.initState();
    pilgrimageNotifier = ref.read(pilgrimageNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pilgrimageNotifier.fetchInitialPilgrimages();
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
          ref.read(pilgrimageNotifierProvider.notifier).searchPilgrimages(q),
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: _clearSearchResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pilgrimState = ref.watch(pilgrimageNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.pilgrimage),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !pilgrimState.isLoading &&
              !pilgrimState.hasReachedMax) {
            pilgrimageNotifier.fetchMorePilgrimages();
          }
          return false;
        },
        child: Column(
          children: [
            _buildSearchBar(context),
            _buildToggleView(),
            pilgrimState.pilgrimages.isEmpty && pilgrimState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : pilgrimState.pilgrimages.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.noRecordFound,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    : Expanded(
                        child: _currentView == ViewType.list
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: pilgrimState.pilgrimages.length +
                                    (pilgrimState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      pilgrimState.pilgrimages.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final pilgrimage =
                                      pilgrimState.pilgrimages[index];

                                  return PilgrimageCardItem(
                                    pilgrimage: pilgrimage,
                                  );
                                },
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: pilgrimState.pilgrimages.length +
                                    (pilgrimState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      pilgrimState.pilgrimages.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final pilgrimage =
                                      pilgrimState.pilgrimages[index];

                                  return PilgrimageCardItem(
                                    pilgrimage: pilgrimage,
                                    isGridView: true,
                                  );
                                },
                              ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.list_alt,
            ),
            onPressed: () {
              setState(() {
                _currentView = ViewType.list;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              setState(() {
                _currentView = ViewType.grid;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 16,
      ),
      child: SearchBar(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => Theme.of(context).colorScheme.surfaceContainer,
        ),
        controller: _searchController,
        focusNode: _searchFocusNode,
        leading: Icon(Icons.search),
        trailing: [
          _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    pilgrimageNotifier.fetchInitialPilgrimages();
                  },
                )
              : const SizedBox(),
        ],
        hintText: AppLocalizations.of(context)!.search,
        onChanged: (value) {
          _performSearch(value);
        },
      ),
    );
  }

  void _clearSearchResults() {
    ref.read(pilgrimageNotifierProvider.notifier).clearSearchResults();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

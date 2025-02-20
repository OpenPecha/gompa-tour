import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/statue_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/util/search_debouncer.dart';

import '../widget/deity_card_item.dart';

enum ViewType { grid, list }

class DeitiesListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/deties-list';

  const DeitiesListScreen({super.key});

  @override
  ConsumerState<DeitiesListScreen> createState() => _DeitiesListScreenState();
}

class _DeitiesListScreenState extends ConsumerState<DeitiesListScreen> {
  ViewType _currentView = ViewType.grid;
  late StatueNotifier statueNotifier;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();

  @override
  void initState() {
    super.initState();
    statueNotifier = ref.read(statueNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statueNotifier.fetchInitialStatues();
    });
  }

  void _performSearch(String query) async {
    _searchDebouncer.run(
      query,
      onSearch: (q) =>
          ref.read(statueNotifierProvider.notifier).searchStatues(q),
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: statueNotifier.fetchInitialStatues,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statueState = ref.watch(statueNotifierProvider);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: GonpaAppBar(title: AppLocalizations.of(context)!.deities),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                !statueState.isLoading &&
                !statueState.hasReachedMax) {
              statueNotifier.fetchMoreStatues();
            }
            return false;
          },
          child: Column(
            children: [
              _buildSearchBar(context),
              _buildToggleView(),
              statueState.isLoading &&
                      (statueState.statues.isEmpty ||
                          _searchController.text.isNotEmpty)
                  ? const Center(child: CircularProgressIndicator())
                  : statueState.statues.isEmpty
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
                                  itemCount: statueState.statues.length +
                                      (statueState.isLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == statueState.statues.length) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final statue = statueState.statues[index];

                                    return DeityCardItem(
                                      statue: statue,
                                    );
                                  },
                                )
                              : GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: statueState.statues.length +
                                      (statueState.isLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == statueState.statues.length) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final statue = statueState.statues[index];
                                    return DeityCardItem(
                                      statue: statue,
                                      isGridView: true,
                                    );
                                  },
                                ),
                        ),
            ],
          ),
        ));
  }

  Widget _buildToggleView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.deities,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.list_alt,
                  color: _currentView == ViewType.list
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  setState(() {
                    _currentView = ViewType.list;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.grid_view,
                  color: _currentView == ViewType.grid
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  setState(() {
                    _currentView = ViewType.grid;
                  });
                },
              ),
            ],
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
                    statueNotifier.fetchInitialStatues();
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
    ref.read(statueNotifierProvider.notifier).clearSearchResults();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

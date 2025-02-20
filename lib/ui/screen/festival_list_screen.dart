import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/ui/widget/festival_card_item.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/util/search_debouncer.dart';

enum ViewType { grid, list }

class FestivalListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/festival-list';

  const FestivalListScreen({super.key});

  @override
  ConsumerState<FestivalListScreen> createState() => _FestivalListScreenState();
}

class _FestivalListScreenState extends ConsumerState<FestivalListScreen> {
  late FestivalNotifier festivalNotifier;
  ViewType _currentView = ViewType.grid;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();

  @override
  void initState() {
    super.initState();
    festivalNotifier = ref.read(festivalNotifierProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      festivalNotifier.fetchInitialFestivals();
    });
  }

  void _performSearch(String query) async {
    _searchDebouncer.run(
      query,
      onSearch: (q) =>
          ref.read(festivalNotifierProvider.notifier).searchFestivals(q),
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: festivalNotifier.fetchInitialFestivals,
    );
  }

  @override
  Widget build(BuildContext context) {
    final festivalState = ref.watch(festivalNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.festival),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !festivalState.isLoading &&
              !festivalState.hasReachedMax) {
            festivalNotifier.fetchPaginatedFestival();
          }
          return false;
        },
        child: Column(
          children: [
            _buildSearchBar(context),
            _buildToggleView(),
            festivalState.isLoading &&
                    (festivalState.festivals.isEmpty ||
                        _searchController.text.isNotEmpty)
                ? const Center(child: CircularProgressIndicator())
                : festivalState.festivals.isEmpty
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
                                itemCount: festivalState.festivals.length +
                                    (festivalState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == festivalState.festivals.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final festival =
                                      festivalState.festivals[index];

                                  return FestivalCardItem(festival: festival);
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
                                itemCount: festivalState.festivals.length +
                                    (festivalState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == festivalState.festivals.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final festival =
                                      festivalState.festivals[index];

                                  return FestivalCardItem(
                                    festival: festival,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.festival,
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
                    festivalNotifier.fetchInitialFestivals();
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

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

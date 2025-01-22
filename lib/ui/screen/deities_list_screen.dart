import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/bottom_nav_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/states/search_state.dart';
import 'package:gompa_tour/ui/screen/home_screen.dart';
import 'package:gompa_tour/ui/screen/skeleton_screen.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/search_card_item.dart';
import 'package:gompa_tour/util/search_debouncer.dart';

import '../../states/deties_state.dart';
import '../widget/deity_card_item.dart';

enum ViewType { grid, list }

class DeitiesListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/deties-list';

  const DeitiesListScreen({super.key});

  @override
  ConsumerState<DeitiesListScreen> createState() => _DeitiesListScreenState();
}

class _DeitiesListScreenState extends ConsumerState<DeitiesListScreen> {
  ViewType _currentView = ViewType.list;
  late DeityNotifier deityNotifier;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();

  @override
  void initState() {
    super.initState();
    deityNotifier = ref.read(detiesNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      deityNotifier.fetchInitialDeities();
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
    final deityState = ref.watch(detiesNotifierProvider);

    return Scaffold(
        appBar: GonpaAppBar(title: AppLocalizations.of(context)!.deities),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                !deityState.isLoading &&
                !deityState.hasReachedMax) {
              deityNotifier.fetchPaginatedDeities();
            }
            return false;
          },
          child: Column(
            children: [
              _buildSearchBar(context),
              _buildToggleView(),
              deityState.deities.isEmpty && deityState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : deityState.deities.isEmpty
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
                                  itemCount: deityState.deities.length +
                                      (deityState.isLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == deityState.deities.length) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final deity = deityState.deities[index];

                                    return DeityCardItem(
                                      deity: deity,
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
                                  itemCount: deityState.deities.length +
                                      (deityState.isLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == deityState.deities.length) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final deity = deityState.deities[index];
                                    return DeityCardItem(
                                      deity: deity,
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
                    deityNotifier.fetchInitialDeities();
                  },
                )
              : const SizedBox(),
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {
              ref.read(bottomNavProvider.notifier).setAndPersistValue(2);
              Navigator.pop(context);
            },
          )
        ],
        hintText: 'Search here....',
        onChanged: (value) {
          _performSearch(value);
        },
      ),
    );
  }

  void _clearSearchResults() {
    ref.read(detiesNotifierProvider.notifier).clearSearchResults();
  }
}

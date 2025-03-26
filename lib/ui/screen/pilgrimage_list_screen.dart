import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/constants/state_data.dart';
import 'package:gompa_tour/states/pilgrim_site_state.dart';
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
  late PilgrimSiteNotifier pilgrimSiteNotifier;
  ViewType _currentView = ViewType.grid;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();
  // var _allStates = [];
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    pilgrimSiteNotifier = ref.read(pilgrimSiteNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialPilgrimSites();
    });
  }

  Future<void> _loadInitialPilgrimSites() async {
    pilgrimSiteNotifier.fetchInitialPilgrimSites();
    // final allStates = await pilgrimSiteNotifier.getUniqueStates();
    // setState(() {
    //   _allStates = allStates;
    // });
  }

  void _performSearch(String query) async {
    _searchDebouncer.run(
      query,
      onSearch: (q) {
        _selectedState = null;
        return ref
            .read(pilgrimSiteNotifierProvider.notifier)
            .searchPilgrimSites(query);
      },
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: pilgrimSiteNotifier.fetchInitialPilgrimSites,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pilgrimSiteState = ref.watch(pilgrimSiteNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.pilgrimage),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !pilgrimSiteState.isLoading &&
              !pilgrimSiteState.hasReachedMax) {
            pilgrimSiteNotifier.fetchMorePilgrimSites();
          }
          return false;
        },
        child: Column(
          children: [
            _buildSearchBar(context),
            _buildToggleView(),
            pilgrimSiteState.isLoading &&
                    (pilgrimSiteState.pilgrimSites.isEmpty ||
                        _searchController.text.isNotEmpty)
                ? const Center(child: CircularProgressIndicator())
                : pilgrimSiteState.pilgrimSites.isEmpty
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
                                itemCount:
                                    pilgrimSiteState.pilgrimSites.length +
                                        (pilgrimSiteState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      pilgrimSiteState.pilgrimSites.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final pilgrimSite =
                                      pilgrimSiteState.pilgrimSites[index];

                                  return PilgrimageCardItem(
                                    pilgrimSite: pilgrimSite,
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
                                itemCount:
                                    pilgrimSiteState.pilgrimSites.length +
                                        (pilgrimSiteState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      pilgrimSiteState.pilgrimSites.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final pilgrimSite =
                                      pilgrimSiteState.pilgrimSites[index];

                                  return PilgrimageCardItem(
                                    pilgrimSite: pilgrimSite,
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
            AppLocalizations.of(context)!.pilgrimage,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // dropdown for unqiue states
          DropdownButton2<String>(
            isExpanded: true,
            value: _selectedState,
            hint: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                AppLocalizations.of(context)!.allStates,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
            items: [
              // DropdownMenuItem<String>(
              //   value: null,
              //   child: Text(
              //     'All States',
              //     style: const TextStyle(fontSize: 14),
              //   ),
              // ),
              ...StateData.stateTranslationForPilgrim.entries.map(
                (state) {
                  return DropdownMenuItem<String>(
                    value: state.key,
                    child: Text(
                      StateData.getLocalizedStateNameForPilgrim(
                        state.key,
                        Localizations.localeOf(context).languageCode,
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ],
            onChanged: (String? value) {
              setState(() {
                _selectedState = value;
              });
              value == null
                  ? _loadInitialPilgrimSites()
                  : pilgrimSiteNotifier.filterPilgrimSites(value);
            },
            buttonStyleData: ButtonStyleData(
              height: 40,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            iconStyleData: IconStyleData(
              icon: _selectedState != null
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedState = null;
                        });
                        _loadInitialPilgrimSites();
                      },
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    )
                  : Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
            ),
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
                    _selectedState = null;
                    pilgrimSiteNotifier.fetchInitialPilgrimSites();
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

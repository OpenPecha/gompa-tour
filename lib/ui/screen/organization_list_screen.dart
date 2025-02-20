import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/ui/screen/deities_list_screen.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/organization_card_item.dart';
import 'package:gompa_tour/util/search_debouncer.dart';

class OrganizationListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/organization-list';
  final String? sect;

  OrganizationListScreen({
    super.key,
    this.sect,
  });

  @override
  ConsumerState createState() => _OrganizationListScreenState();
}

class _OrganizationListScreenState
    extends ConsumerState<OrganizationListScreen> {
  late GonpaNotifier gonpaNotifier;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();
  ViewType _currentView = ViewType.grid;
  String? _selectedType;

  List<String> types = ["MONASTERY", "NUNNERY", "TEMPLE", "NGAKPA", "OTHER"];

  @override
  void initState() {
    super.initState();
    // Fetch initial deities when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialGonpasByCategory();
    });
  }

  void _loadInitialGonpasByCategory() {
    gonpaNotifier = ref.read(gonpaNotifierProvider.notifier);
    gonpaNotifier.fetchInitialGonpasByCategory(widget.sect!);
    gonpaNotifier.fetchAllGonpaTypes();
  }

  void _performSearch(String query) async {
    _searchDebouncer.run(
      query,
      onSearch: (q) {
        if (widget.sect == "All") {
          return gonpaNotifier.searchGonpas(q);
        } else {
          return gonpaNotifier.searchGonpasByCategory(q, widget.sect!);
        }
      },
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: () =>
          gonpaNotifier.fetchInitialGonpasByCategory(widget.sect!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gonpaState = ref.watch(gonpaNotifierProvider);

    print("Gonpa types: ${gonpaState.types}");
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.organization),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !gonpaState.isLoading &&
              !gonpaState.hasReachedMax) {
            gonpaNotifier.fetchMoreGonpasByCategory(widget.sect!);
          }
          return false;
        },
        child: Column(
          children: [
            _buildSearchBar(context),
            _buildToggleView(gonpaState),
            gonpaState.isLoading &&
                    (gonpaState.gonpas.isEmpty ||
                        _searchController.text.isEmpty)
                ? const Center(child: CircularProgressIndicator())
                : gonpaState.gonpas.isEmpty
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
                                itemCount: gonpaState.gonpas.length +
                                    (gonpaState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == gonpaState.gonpas.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final gonpa = gonpaState.gonpas[index];

                                  return OrganizationCardItem(
                                    gonpa: gonpa,
                                  );
                                },
                              )
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: gonpaState.gonpas.length +
                                    (gonpaState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == gonpaState.gonpas.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final gonpa = gonpaState.gonpas[index];

                                  return OrganizationCardItem(
                                    gonpa: gonpa,
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
                    _loadInitialGonpasByCategory();
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

  Widget _buildToggleView(GonpaListState gonpaState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dropdown for gonpa types
          DropdownButton2<String>(
            value: _selectedType,
            hint: Text(
              'Select Types',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(
                  'All Types',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              ...gonpaState.types.map(
                (type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
            onChanged: (String? value) {
              setState(() {
                _selectedType = value;
              });
              value == "All Types"
                  ? _loadInitialGonpasByCategory()
                  : gonpaNotifier.filterGonpas(value!, widget.sect!);
            },
            buttonStyleData: ButtonStyleData(
              height: 40,
              width: 140,
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
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
}

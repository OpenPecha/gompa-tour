import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/organization_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/ui/screen/deities_list_screen.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/organization_card_item.dart';
import 'package:gompa_tour/util/search_debouncer.dart';

class OrganizationListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/organization-list';
  final String? category;

  OrganizationListScreen({
    super.key,
    this.category,
  });

  @override
  ConsumerState createState() => _OrganizationListScreenState();
}

class _OrganizationListScreenState
    extends ConsumerState<OrganizationListScreen> {
  late OrganizationNotifier organizationNotifier;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();
  ViewType _currentView = ViewType.list;

  @override
  void initState() {
    super.initState();
    // Fetch initial deities when the screen is first loaded
    organizationNotifier = ref.read(organizationNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialOrganizations();
    });
  }

  void _loadInitialOrganizations() {
    if (widget.category == "All") {
      organizationNotifier.fetchInitialOrganizations();
    } else {
      organizationNotifier
          .fetchCategorisedInitialOrganizations(widget.category ?? '');
    }
  }

  void _performSearch(String query) async {
    if (query.isEmpty || query.length < 3) {
      _clearSearchResults();
      return;
    }

    _searchDebouncer.run(
      query,
      onSearch: (q) {
        if (widget.category == "All") {
          return organizationNotifier.searchOrganizations(q);
        } else {
          return organizationNotifier.searchOrganizationsByCategory(
              q, widget.category ?? '');
        }
      },
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: _clearSearchResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final organizationState = ref.watch(organizationNotifierProvider);
    return Scaffold(
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.organization),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !organizationState.isLoading &&
              !organizationState.hasReachedMax) {
            if (widget.category == "All") {
              organizationNotifier.fetchPaginatedOrganizations();
            } else {
              organizationNotifier.fetchPaginatedCategorisedOrganizations(
                  widget.category ?? '');
            }
          }
          return false;
        },
        child: Column(
          children: [
            _buildSearchBar(context),
            _buildToggleView(),
            organizationState.organizations.isEmpty &&
                    organizationState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : organizationState.organizations.isEmpty
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
                                    organizationState.organizations.length +
                                        (organizationState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      organizationState.organizations.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final organization =
                                      organizationState.organizations[index];

                                  return OrganizationCardItem(
                                    organization: organization,
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
                                itemCount:
                                    organizationState.organizations.length +
                                        (organizationState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      organizationState.organizations.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final organization =
                                      organizationState.organizations[index];

                                  return OrganizationCardItem(
                                    organization: organization,
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
                    _loadInitialOrganizations();
                  },
                )
              : const SizedBox(),
        ],
        hintText: 'Search here....',
        onChanged: (value) {
          _performSearch(value);
        },
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

  void _clearSearchResults() {
    ref.read(organizationNotifierProvider.notifier).clearSearchResults();
  }
}

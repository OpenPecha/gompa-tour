import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/states/deties_state.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/states/organization_state.dart';
import 'package:gompa_tour/states/pilgrimage_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/states/search_state.dart';
import 'package:gompa_tour/ui/screen/deities_list_screen.dart';
import 'package:gompa_tour/ui/screen/festival_list_screen.dart';
import 'package:gompa_tour/ui/screen/orginatzations_screen.dart';
import 'package:gompa_tour/ui/screen/pilgrimage_list_screen.dart';
import 'package:gompa_tour/ui/widget/search_card_item.dart';
import 'package:gompa_tour/util/enum.dart';
import 'package:gompa_tour/util/search_debouncer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();

  int totalDeity = 0;
  int totalOrganization = 0;
  int totalFestival = 0;
  int totalPilgrimage = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  void _loadCounts() async {
    final deityCount =
        await ref.read(detiesNotifierProvider.notifier).getDeitiesCount();
    final organizationCout = await ref
        .read(organizationNotifierProvider.notifier)
        .getOrganizationCount();
    final festivalCout =
        await ref.read(festivalNotifierProvider.notifier).getFestivalCount();
    final pilgrimageCount = await ref
        .read(pilgrimageNotifierProvider.notifier)
        .getTotalPilgrimages();
    setState(() {
      totalDeity = deityCount;
      totalOrganization = organizationCout;
      totalFestival = festivalCout;
      totalPilgrimage = pilgrimageCount;
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
          ref.read(searchNotifierProvider.notifier).searchAcrossTables(q),
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: _clearSearchResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);

    return Column(
      children: [
        _buildHeader(context),
        _buildSearchBar(context),
        const Divider(),
        _buildCategoryCards(context),
        _buildSearchResults(context, searchState),
        searchState.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    Locale locale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.deptName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          locale.languageCode == 'en'
              ? Text(
                  'Central Tibetan Administration',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : SizedBox(),
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
                    _clearSearchResults();
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

  Widget _buildCategoryCards(BuildContext context) {
    return _searchController.text.isEmpty
        ? Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(8),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
              children: [
                _buildCard(
                  MenuType.deities,
                  'assets/images/buddha.png',
                  context,
                  totalDeity,
                ),
                _buildCard(
                  MenuType.organization,
                  'assets/images/potala2.png',
                  context,
                  totalOrganization,
                ),
                _buildCard(
                  MenuType.pilgrimage,
                  'assets/images/dorjee_den.webp',
                  context,
                  totalPilgrimage,
                ),
                _buildCard(
                  MenuType.festival,
                  'assets/images/duchen.png',
                  context,
                  totalFestival,
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget _buildCard(
      MenuType type, String imagePath, BuildContext context, int count) {
    return GestureDetector(
      onTap: () {
        switch (type) {
          case MenuType.deities:
            context.push(DeitiesListScreen.routeName);
            return;
          case MenuType.organization:
            context.push(OrginatzationsScreen.routeName);
            return;
          case MenuType.festival:
            context.push(FestivalListScreen.routeName);
            return;
          case MenuType.pilgrimage:
            context.push(PilgrimageListScreen.routeName);
            return;
          default:
            break;
        }
      },
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2, // Give less space to text content
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getTitle(type, context),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(count.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      )),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, SearchState searchState) {
    if (searchState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return searchState.results.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemCount: searchState.results.length,
              itemBuilder: (context, index) {
                final searchableItem = searchState.results[index];
                return SearchCardItem(searchableItem: searchableItem);
              },
            ),
          )
        : const SizedBox();
  }

  String _getTitle(MenuType type, BuildContext context) {
    switch (type) {
      case MenuType.deities:
        return AppLocalizations.of(context)!.deities;
      case MenuType.organization:
        return AppLocalizations.of(context)!.organizations;
      case MenuType.festival:
        return AppLocalizations.of(context)!.festival;
      case MenuType.pilgrimage:
        return AppLocalizations.of(context)!.pilgrimage;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  void _clearSearchResults() {
    ref.read(searchNotifierProvider.notifier).clearSearchResults();
  }
}

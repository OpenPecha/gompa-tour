import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/models/gonpa.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/states/organization_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/ui/screen/organization_list_screen.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:gompa_tour/util/search_debouncer.dart';

class OrginatzationsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/organizations-screen';

  const OrginatzationsScreen({super.key});

  @override
  ConsumerState<OrginatzationsScreen> createState() =>
      _OrginatzationsScreenState();
}

class _OrginatzationsScreenState extends ConsumerState<OrginatzationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late GonpaNotifier gonpaNotifier;
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();
  final gonpaStats = [];
  List<Gonpa> gonpas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    gonpaNotifier = ref.read(gonpaNotifierProvider.notifier);
    Future.delayed(Duration.zero, () {
      fetchGonpas();
    });
  }

  Future<void> fetchGonpas() async {
    try {
      final fetchedGonpas = await gonpaNotifier.fetchAllGonpas();
      setState(() {
        gonpas = fetchedGonpas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching gonpas: $e');
    }
  }

  Map<String, List<Gonpa>> get groupedMonasteries {
    return {
      "NYINGMA": gonpas.where((m) => m.sect == Sect.NYINGMA).toList(),
      "KAGYU": gonpas.where((m) => m.sect == Sect.KAGYU).toList(),
      "SAKYA": gonpas.where((m) => m.sect == Sect.SAKYA).toList(),
      "GELUG": gonpas.where((m) => m.sect == Sect.GELUG).toList(),
      "BHON": gonpas.where((m) => m.sect == Sect.BHON).toList(),
      "JONANG": gonpas.where((m) => m.sect == Sect.JONANG).toList(),
      "REMEY": gonpas.where((m) => m.sect == Sect.REMEY).toList(),
      "SHALU": gonpas.where((m) => m.sect == Sect.SHALU).toList(),
      "BODONG": gonpas.where((m) => m.sect == Sect.BODONG).toList(),
      "OTHER": gonpas.where((m) => m.sect == Sect.OTHER).toList(),
    };
  }

  _performSearch(String query) async {
    if (query.isEmpty || query.length < 3) {
      ref.read(organizationNotifierProvider.notifier).clearSearchResults();
      return;
    }

    _searchDebouncer.run(
      query,
      onSearch: (q) => ref
          .read(organizationNotifierProvider.notifier)
          .searchOrganizations(q),
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: () =>
          ref.read(organizationNotifierProvider.notifier).clearSearchResults(),
    );
  }

  // list of organizations
  final organizations = [
    {"All": "All Gonpa"},
    {"CHA0": "Nyingma"},
    {"CHB0": "Kagyu"},
    {"CHC0": "Sakya"},
    {"CHD0": "Gelug"},
    {"CHE0": "Bon"},
    {"CHF0": "Jonang"},
    {"CHG": "Others"},
  ];

  @override
  Widget build(BuildContext context) {
    final organisationState = ref.watch(organizationNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GonpaAppBar(title: ''),
      body: Column(
        children: [
          _buildSearchBar(context),
          organisationState.organizations.isEmpty && organisationState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _searchController.text.length < 3
                  ? _buildSectListCard(context)
                  : organisationState.organizations.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noRecordFound,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : _buildSearchedOrganizations(context, organisationState),
        ],
      ),
    );
  }

  Widget _buildSectListCard(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: groupedMonasteries.length,
        itemBuilder: (context, index) {
          final sect = groupedMonasteries.keys.elementAt(index);
          final monasteries = groupedMonasteries[sect] ?? [];
          return GestureDetector(
            onTap: () {
              // Navigate to the gonpa list screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrganizationListScreen(
                    sect: sect,
                  ),
                ),
              );
            },
            child: Card(
              shadowColor: Theme.of(context).colorScheme.shadow,
              color: Theme.of(context).colorScheme.surfaceContainer,
              margin: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GonpaCacheImage(
                        url: "media/1710929961IMG20220622104550.jpg",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sect.toString(),
                            // _getTitle(organization.values.first, context),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            monasteries.length.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchedOrganizations(
      BuildContext context, OrganizationListState organizationListState) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: organizationListState.organizations.length,
        itemBuilder: (context, index) {
          final organization = organizationListState.organizations[index];
          return null;
          // OrganizationCardItem(
          //   organization: organization,
          // );
        },
      ),
    );
  }

  String _getTitle(String category, BuildContext context) {
    switch (category) {
      case "All":
        return AppLocalizations.of(context)!.allGonpa;
      case "CHA0 རྙིང་མ།":
        return AppLocalizations.of(context)!.nyingma;
      case "CHB0 བཀའ་བརྒྱུད།":
        return AppLocalizations.of(context)!.kagyu;
      case "CHC0 ས་སྐྱ།":
        return AppLocalizations.of(context)!.sakya;
      case "CHD0 དགེ་ལུགས།":
        return AppLocalizations.of(context)!.gelug;
      case "CHE0 བོན།":
        return AppLocalizations.of(context)!.bon;
      case "CHF0 ཇོ་ནང།":
        return AppLocalizations.of(context)!.jonang;
      case "Others":
        return AppLocalizations.of(context)!.others;
      default:
        return AppLocalizations.of(context)!.others;
    }
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

  void _clearSearchResults() {
    ref.read(organizationNotifierProvider.notifier).clearSearchResults();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

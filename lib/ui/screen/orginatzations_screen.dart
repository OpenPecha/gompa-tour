import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/models/gonpa.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/ui/screen/organization_list_screen.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/l10n/generated/app_localizations.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:gompa_tour/ui/widget/organization_card_item.dart';
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
    }
  }

  Map<String, List<Gonpa>> get groupedGonpas {
    return {
      "ALL": gonpas,
      "NYINGMA": gonpas.where((m) => m.sect == "NYINGMA").toList(),
      "KAGYU": gonpas.where((m) => m.sect == "KAGYU").toList(),
      "SAKYA": gonpas.where((m) => m.sect == "SAKYA").toList(),
      "GELUG": gonpas.where((m) => m.sect == "GELUG").toList(),
      "BHON": gonpas.where((m) => m.sect == "BHON").toList(),
      "JONANG": gonpas.where((m) => m.sect == "JONANG").toList(),
      "OTHER": gonpas.where((m) => m.sect == "OTHER").toList(),
    };
  }

  final bgimagelink = {
    'nyingma':
        "${dotenv.env['IMAGE_BASE_URL'] ?? ''}/media/images/1732078167GP205668.jpg",
    'kagyu':
        "${dotenv.env['IMAGE_BASE_URL'] ?? ''}/media/images/1731493541GP205597.jpg",
    'sakya':
        "${dotenv.env['IMAGE_BASE_URL'] ?? ''}/media/images/1732251070GP205684.jpg",
    'gelug':
        "${dotenv.env['IMAGE_BASE_URL'] ?? ''}/media/images/1731488192GP205592.jpg",
    'bhon':
        "${dotenv.env['IMAGE_BASE_URL'] ?? ''}/media/images/1731914731GP205645.jpg",
    'jonang':
        "${dotenv.env['IMAGE_BASE_URL'] ?? ''}/media/images/1731559304GP205604.jpg",
    'other':
        "${dotenv.env['IMAGE_BASE_URL'] ?? ''}/media/images/1732603251GP205716.jpg",
  };

  String getSectImage(String sect) {
    switch (sect) {
      case "NYINGMA":
        return bgimagelink['nyingma']!;
      case "KAGYU":
        return bgimagelink['kagyu']!;
      case "SAKYA":
        return bgimagelink['sakya']!;
      case "GELUG":
        return bgimagelink['gelug']!;
      case "BHON":
        return bgimagelink['bhon']!;
      case "JONANG":
        return bgimagelink['jonang']!;
      case "OTHER":
        return bgimagelink['other']!;
      default:
        return "media/1710929961IMG20220622104550.jpg";
    }
  }

  _performSearch(String query) async {
    _searchDebouncer.run(
      query,
      onSearch: (q) => ref.read(gonpaNotifierProvider.notifier).searchGonpas(q),
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: _clearSearchResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gonpaState = ref.watch(gonpaNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GonpaAppBar(title: ''),
      body: Column(
        children: [
          _buildSearchBar(context),
          isLoading || gonpaState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _searchController.text.isEmpty
                  ? _buildSectListCard(context)
                  : gonpaState.gonpas.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noRecordFound,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : _buildSearchedOrganizations(context, gonpaState),
        ],
      ),
    );
  }

  Widget _buildSectListCard(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: groupedGonpas.length,
        itemBuilder: (context, index) {
          final sect = groupedGonpas.keys.elementAt(index);
          final gonpas = groupedGonpas[sect] ?? [];
          return GestureDetector(
            onTap: () {
              // Navigate to the gonpa list screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrganizationListScreen(
                    sect: sect,
                    gonpas: gonpas,
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
                        url: getSectImage(sect),
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
                            _getTitle(sect.toString(), context),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            gonpas.length.toString(),
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
      BuildContext context, GonpaListState gonpaState) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: gonpaState.gonpas.length,
        itemBuilder: (context, index) {
          final gonpa = gonpaState.gonpas[index];
          return OrganizationCardItem(
            gonpa: gonpa,
          );
        },
      ),
    );
  }

  String _getTitle(String category, BuildContext context) {
    switch (category) {
      case "ALL":
        return AppLocalizations.of(context)!.allGonpa;
      case "NYINGMA":
        return AppLocalizations.of(context)!.nyingma;
      case "KAGYU":
        return AppLocalizations.of(context)!.kagyu;
      case "SAKYA":
        return AppLocalizations.of(context)!.sakya;
      case "GELUG":
        return AppLocalizations.of(context)!.gelug;
      case "BHON":
        return AppLocalizations.of(context)!.bon;
      case "JONANG":
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
    ref.read(gonpaNotifierProvider.notifier).clearSearchResults();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

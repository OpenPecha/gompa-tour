import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';

import '../../states/deties_state.dart';
import 'deties_detail_screen.dart';

class DetiesListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/deties-list';

  const DetiesListScreen({super.key});

  @override
  ConsumerState createState() => _DetiesListScreenState();
}

class _DetiesListScreenState extends ConsumerState<DetiesListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _page = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchDeties();
  }

  Future<void> _fetchDeties() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(detiesNotifierProvider.notifier)
        .fetchDeties(_page, _pageSize);
    setState(() {
      _isLoading = false;
      _page++;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchDeties();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deties = ref.watch(detiesNotifierProvider);

    return Scaffold(
      appBar: const GonpaAppBar(title: 'Deties List'),
      body: deties.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: deties.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == deties.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final deity = deties[index];

                return GestureDetector(
                  onTap: () {
                    ref.read(selectedDeityProvider.notifier).state = deity;
                    context.push(DeityDetailScreen.routeName);
                    // Navigate to the detail screen of the item
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => DetailsScreen(
                    //       title: items[index].title,
                    //       imageUrl: items[index].imgUrl,
                    //       audioUrl:
                    //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                    //       description: items[index].description,
                    //       qrData: items[index].title,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Card(
                    shadowColor: Theme.of(context).colorScheme.shadow,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 0),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deity.enTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Hero(
                                  tag: deity.id,
                                  child: GonpaCacheImage(
                                    url: deity.pic,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  deity.enContent.substring(0, 50),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
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
}

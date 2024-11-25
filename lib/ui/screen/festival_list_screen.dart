import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/festival_card_item.dart';

class FestivalListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/festival-list';

  const FestivalListScreen({super.key});

  @override
  ConsumerState createState() => _FestivalListScreenState();
}

class _FestivalListScreenState extends ConsumerState<FestivalListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _page = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchFestivals();
  }

  Future<void> _fetchFestivals() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(festivalNotifierProvider.notifier)
        .fetchFestivals(_page, _pageSize);
    setState(() {
      _isLoading = false;
      _page++;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchFestivals();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final festivals = ref.watch(festivalNotifierProvider);

    return Scaffold(
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.festival),
      body: festivals.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              itemCount: festivals.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == festivals.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final festival = festivals[index];

                return FestivalCardItem(
                  festival: festival,
                );
              },
            ),
    );
  }
}

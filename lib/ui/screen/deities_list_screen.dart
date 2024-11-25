import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';

import '../../states/deties_state.dart';
import '../widget/deity_card_item.dart';

class DeitiesListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/deties-list';

  const DeitiesListScreen({super.key});

  @override
  ConsumerState createState() => _DetiesListScreenState();
}

class _DetiesListScreenState extends ConsumerState<DeitiesListScreen> {
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
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.deities),
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

                return DeityCardItem(
                  deity: deity,
                );
              },
            ),
    );
  }
}
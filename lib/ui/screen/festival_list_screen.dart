import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/ui/widget/festival_card_item.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';

class FestivalListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/festival-list';

  const FestivalListScreen({super.key});

  @override
  ConsumerState<FestivalListScreen> createState() => _FestivalListScreenState();
}

class _FestivalListScreenState extends ConsumerState<FestivalListScreen> {
  late FestivalNotifier festivalNotifier;
  @override
  void initState() {
    super.initState();
    festivalNotifier = ref.read(festivalNotifierProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      festivalNotifier.fetchInitialFestivals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final festivalState = ref.watch(festivalNotifierProvider);

    return Scaffold(
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.festival),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !festivalState.isLoading &&
              !festivalState.hasReachedMax) {
            festivalNotifier.fetchPaginatedFestival();
          }
          return false;
        },
        child: festivalState.festivals.isEmpty && festivalState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : festivalState.festivals.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noRecordFound,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: festivalState.festivals.length +
                        (festivalState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == festivalState.festivals.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final festival = festivalState.festivals[index];

                      return FestivalCardItem(festival: festival);
                    },
                  ),
      ),
    );
  }
}

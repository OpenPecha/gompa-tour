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
  ConsumerState<DeitiesListScreen> createState() => _DeitiesListScreenState();
}

class _DeitiesListScreenState extends ConsumerState<DeitiesListScreen> {
  late DeityNotifier deityNotifier;
  @override
  void initState() {
    super.initState();
    deityNotifier = ref.read(detiesNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      deityNotifier.fetchInitialDeities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deityState = ref.watch(detiesNotifierProvider);

    return Scaffold(
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.deities),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !deityState.isLoading &&
              !deityState.hasReachedMax) {
            deityNotifier.fetchPaginatedDeities();
          }
          return false;
        },
        child: deityState.deities.isEmpty && deityState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : deityState.deities.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noRecordFound,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: deityState.deities.length +
                        (deityState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == deityState.deities.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final deity = deityState.deities[index];

                      return DeityCardItem(
                        deity: deity,
                      );
                    },
                  ),
      ),
    );
  }
}

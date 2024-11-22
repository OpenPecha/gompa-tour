import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/localization_helper.dart';

import '../../models/deity_model.dart';
import '../../models/organization_model.dart';
import '../../states/deties_state.dart';
import '../../states/organization_state.dart';
import '../screen/deties_detail_screen.dart';
import '../screen/organization_detail_screen.dart';
import 'gonpa_cache_image.dart';

class SearchCardItem extends ConsumerWidget {
  final dynamic searchableItem;
  const SearchCardItem({super.key, required this.searchableItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (searchableItem is Deity) {
          ref.read(selectedDeityProvider.notifier).state =
              searchableItem as Deity;
          context.push(DeityDetailScreen.routeName);
        } else {
          ref.read(selectedOrganizationProvider.notifier).state =
              searchableItem as Organization;
          context.push(OrganizationDetailScreen.routeName);
        }
      },
      child: Stack(
        children: [
          Card(
            shadowColor: Theme.of(context).colorScheme.shadow,
            color: Theme.of(context).colorScheme.surfaceContainer,
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localizedText(
                          enText: searchableItem.enTitle,
                          boText: searchableItem.tbTitle,
                        ),
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
                              tag: searchableItem.id,
                              child: GonpaCacheImage(
                                url: searchableItem.pic,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              context
                                  .localizedText(
                                    enText: searchableItem.enContent,
                                    boText: searchableItem.tbContent,
                                  )
                                  .substring(0, 50),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                        searchableItem is Deity ? 'Deity' : 'Organization'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/festival_model.dart';

import '../../config/constant.dart';
import '../../models/deity_model.dart';
import '../../models/organization_model.dart';
import '../../states/deties_state.dart';
import '../../states/festival_state.dart';
import '../../states/organization_state.dart';
import '../screen/deities_detail_screen.dart';
import '../screen/festival_detail_screen.dart';
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
        } else if (searchableItem is Festival) {
          ref.read(selectedFestivalProvider.notifier).state =
              searchableItem as Festival;
          context.push(FestivalDetailScreen.routeName);
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
                            enText: searchableItem is Festival
                                ? searchableItem.eventEnName
                                : searchableItem.enTitle,
                            boText: searchableItem is Festival
                                ? searchableItem.eventTbName
                                : searchableItem.tbTitle),
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
                              context.localizedText(
                                enText: searchableItem is Festival
                                    ? searchableItem.eventEnName
                                    : searchableItem.enContent,
                                boText: searchableItem is Festival
                                    ? searchableItem.eventTbName
                                    : searchableItem.tbContent,
                                maxLength: kDescriptionMaxLength,
                              ),
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    _getTitle(searchableItem, context),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(searchableItem, BuildContext context) {
    String title = 'Unknown';

    if (searchableItem is Deity) {
      title = AppLocalizations.of(context)!.deity;
    } else if (searchableItem is Festival) {
      title = AppLocalizations.of(context)!.festival;
    } else {
      title = AppLocalizations.of(context)!.organization;
    }
    return title;
  }
}

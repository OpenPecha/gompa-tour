import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/festival.dart';
import 'package:gompa_tour/models/gonpa.dart';
import 'package:gompa_tour/models/pilgrim_site.dart';
import 'package:gompa_tour/models/statue.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/states/pilgrim_site_state.dart';
import 'package:gompa_tour/states/statue_state.dart';
import 'package:gompa_tour/ui/screen/pilgrimage_detail_screen.dart';
import 'package:gompa_tour/util/translation_helper.dart';

import '../../config/constant.dart';
import '../../states/festival_state.dart';
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
        if (searchableItem is Statue) {
          ref.read(selectedStatueProvider.notifier).state =
              searchableItem as Statue;
          context.push(DeityDetailScreen.routeName);
        } else if (searchableItem is Festival) {
          ref.read(selectedFestivalProvider.notifier).state =
              searchableItem as Festival;
          context.push(FestivalDetailScreen.routeName);
        } else if (searchableItem is PilgrimSite) {
          ref.read(selectedPilgrimSiteProvider.notifier).state =
              searchableItem as PilgrimSite;
          context.push(PilgrimageDetailScreen.routeName);
        } else {
          ref.read(selectedGonpaProvider.notifier).state =
              searchableItem as Gonpa;
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
                          enText: TranslationHelper.getTranslatedField(
                              translations: searchableItem.translations,
                              languageCode: "en",
                              fieldGetter: (t) => (t as dynamic).name),
                          boText: TranslationHelper.getTranslatedField(
                              translations: searchableItem.translations,
                              languageCode: "bo",
                              fieldGetter: (t) => (t as dynamic).name),
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
                                url: searchableItem.image,
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
                                enText: TranslationHelper.getTranslatedField(
                                    translations: searchableItem.translations,
                                    languageCode: "en",
                                    fieldGetter: (t) =>
                                        (t as dynamic).description),
                                boText: TranslationHelper.getTranslatedField(
                                    translations: searchableItem.translations,
                                    languageCode: "bo",
                                    fieldGetter: (t) =>
                                        (t as dynamic).description),
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

    if (searchableItem is Statue) {
      title = AppLocalizations.of(context)!.deity;
    } else if (searchableItem is Festival) {
      title = AppLocalizations.of(context)!.festival;
    } else if (searchableItem is PilgrimSite) {
      title = AppLocalizations.of(context)!.pilgrimage;
    } else {
      title = AppLocalizations.of(context)!.organization;
    }
    return title;
  }
}

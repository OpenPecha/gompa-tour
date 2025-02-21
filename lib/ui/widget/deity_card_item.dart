import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/statue.dart';
import 'package:gompa_tour/states/statue_state.dart';
import 'package:gompa_tour/util/translation_helper.dart';

import '../../config/constant.dart';
import '../screen/deities_detail_screen.dart';
import 'gonpa_cache_image.dart';

class DeityCardItem extends ConsumerWidget {
  // final Deity deity;
  final Statue statue;
  final bool isGridView;
  const DeityCardItem(
      {super.key, required this.statue, this.isGridView = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isGridView) {
      return GestureDetector(
        onTap: () {
          ref.read(selectedStatueProvider.notifier).state = statue;
          context.push(DeityDetailScreen.routeName);
        },
        child: Card(
          shadowColor: Theme.of(context).colorScheme.shadow,
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: statue.id,
                    child: GonpaCacheImage(
                      url: statue.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localizedText(
                        enText: TranslationHelper.getTranslatedField(
                            translations: statue.translations,
                            languageCode: "en",
                            fieldGetter: (t) => t.name),
                        boText: TranslationHelper.getTranslatedField(
                            translations: statue.translations,
                            languageCode: 'bo',
                            fieldGetter: (t) => t.name),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: context.getLocalizedHeight(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      context.localizedText(
                        enText: TranslationHelper.getTranslatedField(
                            translations: statue.translations,
                            languageCode: "en",
                            fieldGetter: (t) => t.description),
                        boText: TranslationHelper.getTranslatedField(
                            translations: statue.translations,
                            languageCode: 'bo',
                            fieldGetter: (t) => t.description),
                        maxLength: kDescriptionMaxLength,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        height: context.getLocalizedHeight(),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          ref.read(selectedStatueProvider.notifier).state = statue;
          context.push(DeityDetailScreen.routeName);
        },
        child: Card(
          shadowColor: Theme.of(context).colorScheme.shadow,
          color: Theme.of(context).colorScheme.surfaceContainer,
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localizedText(
                    enText: TranslationHelper.getTranslatedField(
                        translations: statue.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.name),
                    boText: TranslationHelper.getTranslatedField(
                        translations: statue.translations,
                        languageCode: "bo",
                        fieldGetter: (t) => t.name),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: context.getLocalizedHeight(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Hero(
                        tag: statue.id,
                        child: GonpaCacheImage(
                          url: statue.image,
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
                              translations: statue.translations,
                              languageCode: "en",
                              fieldGetter: (t) => t.description),
                          boText: TranslationHelper.getTranslatedField(
                              translations: statue.translations,
                              languageCode: "bo",
                              fieldGetter: (t) => t.description),
                          maxLength: kDescriptionMaxLength,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          height: context.getLocalizedHeight(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

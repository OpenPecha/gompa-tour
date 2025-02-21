import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gompa_tour/states/pilgrim_site_state.dart';
import 'package:gompa_tour/ui/widget/address_card.dart';
import 'package:gompa_tour/ui/widget/card_tag.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:gompa_tour/ui/widget/location_card.dart';
import 'package:gompa_tour/util/translation_helper.dart';

class PilgrimageDetailScreen extends ConsumerWidget {
  static const String routeName = '/pilgrimage-detail';
  const PilgrimageDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPilgrimSite = ref.watch(selectedPilgrimSiteProvider);

    if (selectedPilgrimSite == null) {
      return const Scaffold(
        appBar: GonpaAppBar(title: 'Pilgrimage Detail'),
        body: Center(child: Text('No pilgrim selected')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GonpaAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  context.localizedText(
                    enText: TranslationHelper.getTranslatedField(
                        translations: selectedPilgrimSite.translations,
                        languageCode: 'en',
                        fieldGetter: (t) => t.name),
                    boText: TranslationHelper.getTranslatedField(
                        translations: selectedPilgrimSite.translations,
                        languageCode: 'bo',
                        fieldGetter: (t) => t.name),
                  ),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: context.getLocalizedHeight(),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: selectedPilgrimSite.id,
                  child: GonpaCacheImage(
                    url: selectedPilgrimSite.image,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Tag(
                    text: context.localizedText(
                      enText: TranslationHelper.getTranslatedField(
                        translations: selectedPilgrimSite.contact!.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.state,
                      ),
                      boText: TranslationHelper.getTranslatedField(
                        translations: selectedPilgrimSite.contact!.translations,
                        languageCode: 'bo',
                        fieldGetter: (t) => t.state,
                      ),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    textColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  Tag(
                    text: context.localizedText(
                      enText: TranslationHelper.getTranslatedField(
                        translations: selectedPilgrimSite.contact!.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.country,
                      ),
                      boText: TranslationHelper.getTranslatedField(
                        translations: selectedPilgrimSite.contact!.translations,
                        languageCode: 'bo',
                        fieldGetter: (t) => t.country,
                      ),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    textColor:
                        Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                context.localizedText(
                  enText: TranslationHelper.getTranslatedField(
                    translations: selectedPilgrimSite.translations,
                    languageCode: "en",
                    fieldGetter: (t) => t.description,
                  ),
                  boText: TranslationHelper.getTranslatedField(
                    translations: selectedPilgrimSite.translations,
                    languageCode: "bo",
                    fieldGetter: (t) => t.description,
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  height: context.getLocalizedHeight(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              AddressCard(
                contact: selectedPilgrimSite.contact!,
                translations: selectedPilgrimSite.translations,
                geoLocation: selectedPilgrimSite.geoLocation,
              ),
              const SizedBox(
                height: 16,
              ),
              LocationCard(
                address: selectedPilgrimSite,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

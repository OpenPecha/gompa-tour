import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/config/constant.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/states/statue_state.dart';
import 'package:gompa_tour/ui/widget/gonap_qr_card.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:gompa_tour/util/translation_helper.dart';

import '../widget/speaker_widget.dart';

class DeityDetailScreen extends ConsumerWidget {
  static const String routeName = '/deity-detail';
  const DeityDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatue = ref.watch(selectedStatueProvider);
    Locale locale = Localizations.localeOf(context);
    String langBase = locale.languageCode == "bo" ? "bod" : "en";

    if (selectedStatue == null) {
      return const Scaffold(
        appBar: GonpaAppBar(title: 'Deity Detail'),
        body: Center(child: Text('No deity selected')),
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
                        translations: selectedStatue.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.name),
                    boText: TranslationHelper.getTranslatedField(
                        translations: selectedStatue.translations,
                        languageCode: "bo",
                        fieldGetter: (t) => t.name),
                  ),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: context.getLocalizedHeight(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: selectedStatue.id,
                  child: GonpaCacheImage(
                    url: selectedStatue.image,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SpeakerWidget(
                audioUrl: context.localizedText(
                    enText: TranslationHelper.getTranslatedField(
                        translations: selectedStatue.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.descriptionAudio),
                    boText: TranslationHelper.getTranslatedField(
                        translations: selectedStatue.translations,
                        languageCode: "bo",
                        fieldGetter: (t) => t.descriptionAudio)),
                description: context.localizedText(
                    enText: TranslationHelper.getTranslatedField(
                        translations: selectedStatue.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.description),
                    boText: TranslationHelper.getTranslatedField(
                        translations: selectedStatue.translations,
                        languageCode: "bo",
                        fieldGetter: (t) => t.description)),
                data: selectedStatue,
              ),
              const SizedBox(height: 16),
              Text(
                context.localizedText(
                  enText: TranslationHelper.getTranslatedField(
                      translations: selectedStatue.translations,
                      languageCode: "en",
                      fieldGetter: (t) => t.description),
                  boText: TranslationHelper.getTranslatedField(
                      translations: selectedStatue.translations,
                      languageCode: "bo",
                      fieldGetter: (t) => t.description),
                ),
                style: TextStyle(
                  fontSize: 16,
                  height: context.getLocalizedHeight(),
                ),
              ),
              const SizedBox(height: 16),
              GonpaQRCard(
                  qrData: KBaseUrl + langBase + "/Statue/${selectedStatue.id}"),
            ],
          ),
        ),
      ),
    );
  }
}

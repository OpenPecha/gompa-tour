import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:gompa_tour/ui/widget/location_card.dart';
import 'package:gompa_tour/util/translation_helper.dart';

import '../../config/constant.dart';
import '../widget/address_card.dart';
import '../widget/gonap_qr_card.dart';
import '../widget/speaker_widget.dart';

class OrganizationDetailScreen extends ConsumerWidget {
  static const String routeName = '/organization-detail';
  const OrganizationDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGonpa = ref.watch(selectedGonpaProvider);

    if (selectedGonpa == null) {
      return const Scaffold(
        appBar: GonpaAppBar(title: 'Gonpa Detail'),
        body: Center(child: Text('No Gonpa selected')),
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
                        translations: selectedGonpa.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.name),
                    boText: TranslationHelper.getTranslatedField(
                        translations: selectedGonpa.translations,
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
                  tag: selectedGonpa.id,
                  child: GonpaCacheImage(
                    url: selectedGonpa.image,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SpeakerWidget(
                audioUrl: context.localizedText(
                    enText: TranslationHelper.getTranslatedField(
                        translations: selectedGonpa.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.descriptionAudio),
                    boText: TranslationHelper.getTranslatedField(
                        translations: selectedGonpa.translations,
                        languageCode: "bo",
                        fieldGetter: (t) => t.descriptionAudio)),
                description: context.localizedText(
                    enText: TranslationHelper.getTranslatedField(
                        translations: selectedGonpa.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.description),
                    boText: TranslationHelper.getTranslatedField(
                        translations: selectedGonpa.translations,
                        languageCode: "bo",
                        fieldGetter: (t) => t.description)),
                data: selectedGonpa,
              ),
              const SizedBox(height: 16),
              Text(
                context.localizedText(
                    enText: TranslationHelper.getTranslatedField(
                        translations: selectedGonpa.translations,
                        languageCode: "en",
                        fieldGetter: (t) => t.description),
                    boText: TranslationHelper.getTranslatedField(
                        translations: selectedGonpa.translations,
                        languageCode: "bo",
                        fieldGetter: (t) => t.description)),
                style: TextStyle(
                  fontSize: 16,
                  height: context.getLocalizedHeight(),
                ),
              ),
              const SizedBox(height: 16),
              AddressCard(
                address: selectedGonpa,
              ),
              const SizedBox(
                height: 16,
              ),
              LocationCard(
                address: selectedGonpa,
              ),
              ...[
                const SizedBox(height: 16),
                //   GonpaQRCard(
                //       qrData: kOrganizationQrCodeUrl + selectedOrganization.slug)
              ],
            ],
          ),
        ),
      ),
    );
  }
}

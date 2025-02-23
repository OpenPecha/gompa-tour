import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/contact.dart';
import 'package:gompa_tour/util/translation_helper.dart';

class AddressCard extends StatelessWidget {
  final List<dynamic> translations;
  final Contact? contact;
  final String geoLocation;
  const AddressCard(
      {super.key,
      required this.translations,
      this.contact,
      required this.geoLocation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shadowColor: Theme.of(context).colorScheme.shadow,
          color: Theme.of(context).colorScheme.surfaceContainer,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.address,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (translations.isNotEmpty) ...[
                  Text(
                    'Name: ${context.localizedText(
                      enText: TranslationHelper.getTranslatedField(
                          translations: translations,
                          languageCode: "en",
                          fieldGetter: (t) => t.name),
                      boText: TranslationHelper.getTranslatedField(
                          translations: translations,
                          languageCode: "bo",
                          fieldGetter: (t) => t.name),
                    )}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (contact!.translations.isNotEmpty) ...[
                  Text(
                    'Address: ${context.localizedText(
                      enText: TranslationHelper.getTranslatedField(
                          translations: contact!.translations,
                          languageCode: "en",
                          fieldGetter: (t) => t.address),
                      boText: TranslationHelper.getTranslatedField(
                          translations: contact!.translations,
                          languageCode: "bo",
                          fieldGetter: (t) => t.address),
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'State: ${context.localizedText(
                      enText: TranslationHelper.getTranslatedField(
                          translations: contact!.translations,
                          languageCode: "en",
                          fieldGetter: (t) => t.state),
                      boText: TranslationHelper.getTranslatedField(
                          translations: contact!.translations,
                          languageCode: "bo",
                          fieldGetter: (t) => t.state),
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Postal Code: ${context.localizedText(
                      enText: TranslationHelper.getTranslatedField(
                          translations: contact!.translations,
                          languageCode: "en",
                          fieldGetter: (t) => t.postalCode!),
                      boText: TranslationHelper.getTranslatedField(
                          translations: contact!.translations,
                          languageCode: "bo",
                          fieldGetter: (t) => t.postalCode!),
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Country: ${context.localizedText(
                      enText: TranslationHelper.getTranslatedField(
                          translations: contact!.translations,
                          languageCode: "en",
                          fieldGetter: (t) => t.country),
                      boText: TranslationHelper.getTranslatedField(
                          translations: contact!.translations,
                          languageCode: "bo",
                          fieldGetter: (t) => t.country),
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (contact != null) ...[
                  Text(
                    'Phone: ${contact!.phoneNumber}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${contact!.email}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (geoLocation.isNotEmpty) ...[
                  Text(
                    'Map: $geoLocation',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

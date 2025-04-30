import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/ui/widget/gonap_qr_card.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';

import '../../config/constant.dart';

class FestivalDetailScreen extends ConsumerWidget {
  static const String routeName = '/festival-detail';
  const FestivalDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFestival = ref.watch(selectedFestivalProvider);
    Locale locale = Localizations.localeOf(context);
    String langBase = locale.languageCode == "bo" ? "bod" : "en";

    if (selectedFestival == null) {
      return const Scaffold(
        appBar: GonpaAppBar(title: 'Festival Detail'),
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
                    enText: selectedFestival.translations[1].name,
                    boText: selectedFestival.translations[0].name,
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
                  tag: selectedFestival.id,
                  child: GonpaCacheImage(
                    url: selectedFestival.image,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.localizedText(
                  enText: selectedFestival.translations[1].description,
                  boText: selectedFestival.translations[0].description,
                ),
                style: TextStyle(
                  fontSize: 16,
                  height: context.getLocalizedHeight(),
                ),
              ),
              const SizedBox(height: 16),
              GonpaQRCard(
                  qrData:
                      "$kBaseUrl/$langBase/Festival/${selectedFestival.id}"),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

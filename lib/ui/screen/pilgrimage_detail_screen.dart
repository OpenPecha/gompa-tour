import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gompa_tour/states/pilgrimage_state.dart';
import 'package:gompa_tour/ui/widget/card_tag.dart';
import 'package:gompa_tour/ui/widget/gonap_qr_card.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';

class PilgrimageDetailScreen extends ConsumerWidget {
  static const String routeName = '/pilgrimage-detail';
  const PilgrimageDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPilgrimage = ref.watch(selectedPilgrimageProvider);
    final height = MediaQuery.of(context).size.height;

    if (selectedPilgrimage == null) {
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
                    enText: selectedPilgrimage.enName!,
                    boText: selectedPilgrimage.boName!,
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
                  tag: selectedPilgrimage.id,
                  child: GonpaCacheImage(
                    url: selectedPilgrimage.image,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Tag(
                    text: selectedPilgrimage.state,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    textColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  Tag(
                    text: selectedPilgrimage.country,
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
                  enText: selectedPilgrimage.enDescription!,
                  boText: selectedPilgrimage.boDescription!,
                ),
                style: TextStyle(
                  fontSize: 16,
                  height: context.getLocalizedHeight(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

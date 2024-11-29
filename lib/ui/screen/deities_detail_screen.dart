import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/ui/widget/gonap_qr_card.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';

import '../../config/constant.dart';
import '../../states/deties_state.dart';
import '../widget/speaker_widget.dart';

class DeityDetailScreen extends ConsumerWidget {
  static const String routeName = '/deity-detail';
  const DeityDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDeity = ref.watch(selectedDeityProvider);
    final height = MediaQuery.of(context).size.height;

    if (selectedDeity == null) {
      return const Scaffold(
        appBar: GonpaAppBar(title: 'Deity Detail'),
        body: Center(child: Text('No deity selected')),
      );
    }

    return Scaffold(
      appBar: GonpaAppBar(
          title: context.localizedText(
              enText: selectedDeity.enTitle, boText: selectedDeity.tbContent)),
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
                    enText: selectedDeity.enTitle,
                    boText: selectedDeity.tbTitle,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: selectedDeity.id,
                  child: GonpaCacheImage(
                    url: selectedDeity.pic,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedDeity.tbsound != null)
                SpeakerWidget(
                    audioUrl: context.localizedText(
                        enText: selectedDeity.ensound ?? '',
                        boText: selectedDeity.tbsound ?? ''),
                    description: selectedDeity.enContent),
              const SizedBox(height: 16),
              Text(
                context.localizedText(
                  enText: selectedDeity.enContent,
                  boText: selectedDeity.tbContent,
                ),
                style: TextStyle(
                    fontSize: 16, height: context.getLocalizedHeight()),
              ),
              if (selectedDeity.slug != null) ...[
                const SizedBox(height: 16),
                GonpaQRCard(qrData: kDetiesQrCodeBaseUrl + selectedDeity.slug!)
              ],
            ],
          ),
        ),
      ),
    );
  }
}

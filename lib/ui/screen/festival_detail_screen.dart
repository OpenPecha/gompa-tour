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
    final height = MediaQuery.of(context).size.height;

    if (selectedFestival == null) {
      return const Scaffold(
        appBar: GonpaAppBar(title: 'Festival Detail'),
        body: Center(child: Text('No deity selected')),
      );
    }

    return Scaffold(
      appBar: GonpaAppBar(
          title: context.localizedText(
        enText: selectedFestival.eventEnName!,
        boText: selectedFestival.eventTbName!,
      )),
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
                    enText: selectedFestival.eventEnName!,
                    boText: selectedFestival.eventTbName!,
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
                  tag: selectedFestival.id,
                  child: GonpaCacheImage(
                    url: selectedFestival.pic,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.localizedText(
                  enText: selectedFestival.enDescription!,
                  boText: selectedFestival.tbDescription!,
                ),
                style: TextStyle(
                    fontSize: 16, height: context.getLocalizedHeight()),
              ),
              if (selectedFestival.slug != null) ...[
                const SizedBox(height: 16),
                GonpaQRCard(qrData: kEventQrCodeUrl + selectedFestival.slug!),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

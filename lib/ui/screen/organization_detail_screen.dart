import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/states/organization_state.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:gompa_tour/ui/widget/location_card.dart';

import '../widget/address_card.dart';
import '../widget/gonap_qr_card.dart';
import '../widget/speaker_widget.dart';

class OrganizationDetailScreen extends ConsumerWidget {
  static const String routeName = '/organization-detail';
  const OrganizationDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOrganization = ref.watch(selectedOrganizationProvider);

    if (selectedOrganization == null) {
      return const Scaffold(
        appBar: GonpaAppBar(title: 'Organization Detail'),
        body: Center(child: Text('No organization selected')),
      );
    }
    return Scaffold(
      appBar: GonpaAppBar(
          title: context.localizedText(
              enText: selectedOrganization.enTitle,
              boText: selectedOrganization.tbContent)),
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
                    enText: selectedOrganization.enTitle,
                    boText: selectedOrganization.tbTitle,
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
                  tag: selectedOrganization.id,
                  child: GonpaCacheImage(
                    url: selectedOrganization.pic,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedOrganization.sound != null)
                SpeakerWidget(
                    audioUrl: selectedOrganization.sound!,
                    description: context.localizedText(
                        enText: selectedOrganization.enContent,
                        boText: selectedOrganization.tbContent)),
              const SizedBox(height: 16),
              Text(
                context.localizedText(
                  enText: selectedOrganization.enContent,
                  boText: selectedOrganization.tbContent,
                ),
                style: TextStyle(
                    fontSize: 16, height: context.getLocalizedHeight()),
              ),
              const SizedBox(height: 16),
              AddressCard(
                address: selectedOrganization,
              ),
              const SizedBox(
                height: 16,
              ),
              LocationCard(
                address: selectedOrganization,
              ),
              ...[
                const SizedBox(height: 16),
                GonpaQRCard(slug: selectedOrganization.slug)
              ],
            ],
          ),
        ),
      ),
    );
  }
}

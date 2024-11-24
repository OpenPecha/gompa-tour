import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/organization_model.dart';
import 'package:gompa_tour/states/organization_state.dart';
import 'package:gompa_tour/ui/screen/organization_detail_screen.dart';

import '../../config/constant.dart';
import 'gonpa_cache_image.dart';

class OrganizationCardItem extends ConsumerWidget {
  final Organization organization;
  const OrganizationCardItem({super.key, required this.organization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedOrganizationProvider.notifier).state = organization;
        context.push(OrganizationDetailScreen.routeName);
      },
      child: Card(
        shadowColor: Theme.of(context).colorScheme.shadow,
        color: Theme.of(context).colorScheme.surfaceContainer,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localizedText(
                  enText: organization.enTitle,
                  boText: organization.tbTitle,
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Hero(
                      tag: organization.id,
                      child: GonpaCacheImage(
                        url: organization.pic,
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
                        enText: organization.enContent,
                        boText: organization.tbContent,
                        maxLength: kDescriptionMaxLength,
                      ),
                      style: const TextStyle(fontSize: 16),
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

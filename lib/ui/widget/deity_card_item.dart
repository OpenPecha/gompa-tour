import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/localization_helper.dart';

import '../../config/constant.dart';
import '../../models/deity_model.dart';
import '../../states/deties_state.dart';
import '../screen/deities_detail_screen.dart';
import 'gonpa_cache_image.dart';

class DeityCardItem extends ConsumerWidget {
  final Deity deity;
  const DeityCardItem({super.key, required this.deity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale locale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: () {
        ref.read(selectedDeityProvider.notifier).state = deity;
        context.push(DeityDetailScreen.routeName);
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
                  enText: deity.enTitle,
                  boText: deity.tbTitle,
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: context.getLocalizedHeight(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Hero(
                      tag: deity.id,
                      child: GonpaCacheImage(
                        url: deity.pic,
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
                        enText: deity.enContent,
                        boText: deity.tbContent,
                        maxLength: kDescriptionMaxLength,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        height: context.getLocalizedHeight(),
                      ),
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

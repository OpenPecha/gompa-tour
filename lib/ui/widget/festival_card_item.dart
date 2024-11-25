import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/festival_model.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/ui/screen/festival_detail_screen.dart';

import '../../config/constant.dart';
import 'gonpa_cache_image.dart';

class FestivalCardItem extends ConsumerWidget {
  final Festival festival;
  const FestivalCardItem({super.key, required this.festival});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale locale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: () {
        ref.read(selectedFestivalProvider.notifier).state = festival;
        context.push(FestivalDetailScreen.routeName);
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
                  enText: festival.eventEnname!,
                  boText: festival.eventTbname!,
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
                      tag: festival.id,
                      child: GonpaCacheImage(
                        url: festival.pic,
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
                        enText: festival.enDescription!,
                        boText: festival.tbDescription!,
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

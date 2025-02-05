import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/config/constant.dart';
import 'package:gompa_tour/models/festival_model.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/ui/screen/festival_detail_screen.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:gompa_tour/helper/localization_helper.dart';

class PilgrimageCardItem extends ConsumerWidget {
  final Festival festival;
  final bool isGridView;
  const PilgrimageCardItem(
      {Key? key, required this.festival, this.isGridView = false})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isGridView) {
      return GestureDetector(
        onTap: () {
          ref.read(selectedFestivalProvider.notifier).state = festival;
          context.push(FestivalDetailScreen.routeName);
        },
        child: Card(
          shadowColor: Theme.of(context).colorScheme.shadow,
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: festival.id,
                    child: GonpaCacheImage(
                      url: festival.pic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localizedText(
                        enText: festival.eventEnName!,
                        boText: festival.eventTbName!,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: context.getLocalizedHeight(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      context.localizedText(
                        enText: festival.enDescription!,
                        boText: festival.tbDescription!,
                        maxLength: kDescriptionMaxLength,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        height: context.getLocalizedHeight(),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          ref.read(selectedFestivalProvider.notifier).state = festival;
          context.push(FestivalDetailScreen.routeName);
        },
        child: Card(
          shadowColor: Theme.of(context).colorScheme.shadow,
          color: Theme.of(context).colorScheme.surfaceContainer,
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localizedText(
                    enText: festival.eventEnName!,
                    boText: festival.eventTbName!,
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
                      style: TextStyle(
                        fontSize: 16,
                        height: context.getLocalizedHeight(),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

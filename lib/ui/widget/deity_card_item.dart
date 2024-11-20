import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/deity_model.dart';
import '../../states/deties_state.dart';
import '../screen/deties_detail_screen.dart';
import 'gonpa_cache_image.dart';

class DeityCardItem extends ConsumerWidget {
  final Deity deity;
  const DeityCardItem({super.key, required this.deity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                deity.enTitle,
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
                      deity.enContent.substring(0, 50),
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

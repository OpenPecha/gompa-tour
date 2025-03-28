import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/deity_model.dart';
import '../../models/organization_model.dart';
import '../../states/deties_state.dart';
import '../../states/global_audio_state.dart';
import '../../states/organization_state.dart';
import '../screen/deities_detail_screen.dart';
import '../screen/organization_detail_screen.dart';

class PersistentAudioPlayer extends ConsumerWidget {
  final GoRouter router;
  const PersistentAudioPlayer(this.router, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(globalAudioPlayerProvider);

    if (audioState.currentAudioUrl == null) {
      return const SizedBox.shrink();
    }
    final topPadding = MediaQuery.of(context).padding.top;

    return Material(
      elevation: 4,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainer,
        padding: EdgeInsets.only(
            left: 16, right: 16, top: topPadding + 8, bottom: 8),
        child: Row(
          children: [
            // Audio details
            Expanded(
              child: InkResponse(
                onTap: () {
                  final data = audioState.contextData;
                  if (data != null) {
                    final currentLocation = router.state.path;
                    if (data is Organization) {
                      final currentSelectedOrg =
                          ref.read(selectedOrganizationProvider);
                      if (currentLocation !=
                              OrganizationDetailScreen.routeName ||
                          currentSelectedOrg?.id != data.id) {
                        ref.read(selectedOrganizationProvider.notifier).state =
                            data;
                        if (currentLocation ==
                            OrganizationDetailScreen.routeName) {
                          router.pushReplacement(
                              OrganizationDetailScreen.routeName);
                        } else {
                          router.push(OrganizationDetailScreen.routeName);
                        }
                      }
                    } else if (data is Deity) {
                      final currentSelectedDeity =
                          ref.read(selectedDeityProvider);
                      if (currentLocation != DeityDetailScreen.routeName ||
                          currentSelectedDeity?.id != data.id) {
                        ref.read(selectedDeityProvider.notifier).state = data;
                        if (currentLocation == DeityDetailScreen.routeName) {
                          router.pushReplacement(DeityDetailScreen.routeName);
                        } else {
                          router.push(DeityDetailScreen.routeName);
                        }
                      }
                    }
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      audioState.currentAudioUrl?.split('/').last ?? 'Audio',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (audioState.totalDuration != null)
                      Text(
                        '${audioState.currentPosition?.toString().split('.').first ?? '0:00'} / '
                        '${audioState.totalDuration?.toString().split('.').first ?? '0:00'}',
                        style:
                            const TextStyle(fontSize: 12, fontFamily: 'Roboto'),
                      ),
                  ],
                ),
              ),
            ),

            // Control Buttons
            IconButton(
              icon: Icon(audioState.isLoading
                  ? Icons.autorenew
                  : (audioState.isPlaying ? Icons.pause : Icons.play_arrow)),
              onPressed: () {
                final notifier = ref.read(globalAudioPlayerProvider.notifier);
                if (audioState.isLoading) return;

                audioState.isPlaying ? notifier.pause() : notifier.resume();
              },
            ),

            // Close button
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                ref.read(globalAudioPlayerProvider.notifier).stop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/global_audio_state.dart';

class PersistentAudioPlayer extends ConsumerWidget {
  const PersistentAudioPlayer({super.key});

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

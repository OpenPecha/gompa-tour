import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/global_audio_state.dart';

class AudioPlayerWidget extends ConsumerWidget {
  final String audioUrl;
  final String? title;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(globalAudioPlayerProvider);

    // Check if this specific audio is currently playing
    final isCurrentAudio = audioState.currentAudioUrl == audioUrl;

    return Row(
      children: [
        IconButton.filled(
          icon: _buildButtonIcon(audioState, isCurrentAudio),
          onPressed: () {
            final notifier = ref.read(globalAudioPlayerProvider.notifier);

            // If this audio is not current, play it
            if (!isCurrentAudio) {
              notifier.play(audioUrl);
              return;
            }

            // If current audio is playing, pause. If paused, resume
            if (audioState.isPlaying) {
              notifier.pause();
            } else {
              notifier.resume();
            }
          },
          tooltip: _getTooltip(audioState, isCurrentAudio),
        ),
      ],
    );
  }

  Widget _buildButtonIcon(GlobalAudioPlayerState state, bool isCurrentAudio) {
    if (isCurrentAudio && state.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    }

    // Show play or pause based on current audio state
    if (isCurrentAudio) {
      return Icon(
        state.isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
      );
    }

    // Default play icon if not current audio
    return const Icon(
      Icons.play_arrow,
      color: Colors.white,
    );
  }

  String _getTooltip(GlobalAudioPlayerState state, bool isCurrentAudio) {
    if (isCurrentAudio && state.isLoading) {
      return "Loading";
    }

    if (isCurrentAudio) {
      return state.isPlaying ? "Pause" : "Play";
    }

    return "Play";
  }
}

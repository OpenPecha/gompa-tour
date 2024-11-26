import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a provider for audio player state
final audioPlayerStateProvider = StateNotifierProvider.family<
    AudioPlayerStateNotifier, AudioPlayerState, String>((ref, audioUrl) {
  return AudioPlayerStateNotifier(audioUrl);
});

// Define the state class with explicit loading flag
class AudioPlayerState {
  final bool isPlaying;
  final bool isLoading;
  final PlayerState playerState;

  AudioPlayerState({
    this.isPlaying = false,
    this.isLoading = false,
    this.playerState = PlayerState.stopped,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    PlayerState? playerState,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      playerState: playerState ?? this.playerState,
    );
  }
}

// State notifier to manage audio player state
class AudioPlayerStateNotifier extends StateNotifier<AudioPlayerState> {
  final String audioUrl;
  late AudioPlayer _audioPlayer;

  AudioPlayerStateNotifier(this.audioUrl) : super(AudioPlayerState()) {
    _audioPlayer = AudioPlayer();

    // Add listeners to track audio player state
    _audioPlayer.onPlayerStateChanged.listen((PlayerState playerState) {
      state = state.copyWith(
        isPlaying: playerState == PlayerState.playing,
        playerState: playerState,
        isLoading: false, // Reset loading when state changes
      );
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      state = state.copyWith(
        isPlaying: false,
        playerState: PlayerState.completed,
      );
    });
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Set loading to true before attempting to play
      state = state.copyWith(isLoading: true);
      try {
        await _audioPlayer.play(UrlSource(audioUrl));
      } catch (e) {
        // Handle any errors during play
        state = state.copyWith(
          isLoading: false,
          isPlaying: false,
          playerState: PlayerState.stopped,
        );
        rethrow;
      }
    }
  }

  Future<void> dispose() async {
    super.dispose();
    await _audioPlayer.dispose();
  }
}

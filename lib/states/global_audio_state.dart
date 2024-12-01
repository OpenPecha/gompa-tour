import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Global audio player state provider
final globalAudioPlayerProvider =
    StateNotifierProvider<GlobalAudioPlayerNotifier, GlobalAudioPlayerState>(
        (ref) {
  return GlobalAudioPlayerNotifier();
});

// State class for global audio player
class GlobalAudioPlayerState {
  final String? currentAudioUrl;
  final bool isPlaying;
  final bool isLoading;
  final Duration? currentPosition;
  final Duration? totalDuration;
  final dynamic contextData;

  GlobalAudioPlayerState({
    this.currentAudioUrl,
    this.isPlaying = false,
    this.isLoading = false,
    this.currentPosition,
    this.totalDuration,
    this.contextData,
  });

  GlobalAudioPlayerState copyWith({
    String? currentAudioUrl,
    bool? isPlaying,
    bool? isLoading,
    Duration? currentPosition,
    Duration? totalDuration,
    dynamic contextData,
  }) {
    return GlobalAudioPlayerState(
      currentAudioUrl: currentAudioUrl ?? this.currentAudioUrl,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      contextData: contextData ?? this.contextData,
    );
  }
}

// Notifier to manage global audio player state
class GlobalAudioPlayerNotifier extends StateNotifier<GlobalAudioPlayerState> {
  late AudioPlayer _audioPlayer;

  GlobalAudioPlayerNotifier() : super(GlobalAudioPlayerState()) {
    _audioPlayer = AudioPlayer();

    // Track player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState playerState) {
      state = state.copyWith(
        isPlaying: playerState == PlayerState.playing,
        isLoading: false,
      );
    });

    // Track audio duration
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      state = state.copyWith(totalDuration: duration);
    });

    // Track current position
    _audioPlayer.onPositionChanged.listen((Duration position) {
      state = state.copyWith(currentPosition: position);
    });

    // Handle audio completion
    _audioPlayer.onPlayerComplete.listen((_) {
      state = GlobalAudioPlayerState(); // Reset state
    });
  }

  Future<void> play(String audioUrl, dynamic data) async {
    data = data;
    if (state.currentAudioUrl != audioUrl) {
      // New audio source
      state = GlobalAudioPlayerState(
        currentAudioUrl: audioUrl,
        isLoading: true,
        contextData: data,
      );
    }

    try {
      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      state = GlobalAudioPlayerState(); // Reset on error
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    state = GlobalAudioPlayerState(); // Reset state
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

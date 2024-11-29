import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/language_state.dart';
import 'audio_player.dart';
import 'flutter_tts_speaker.dart';

class SpeakerWidget extends ConsumerWidget {
  final String audioUrl;
  final String description;

  const SpeakerWidget(
      {super.key, required this.audioUrl, required this.description});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LanguageState currentLanguage = ref.watch(languageProvider);

    return currentLanguage.currentLanguage == "en"
        ? (audioUrl.isEmpty
            ? FlutterTtsSpeaker(
                text: description,
              )
            : AudioPlayerWidget(audioUrl: audioUrl))
        : audioUrl.isEmpty
            ? SizedBox()
            : AudioPlayerWidget(audioUrl: audioUrl);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../states/language_state.dart';
import 'audio_player.dart';
import 'flutter_tts_speaker.dart';

class SpeakerWidget extends ConsumerWidget {
  final String audioUrl;
  final String description;
  final dynamic data;

  const SpeakerWidget(
      {super.key,
      required this.audioUrl,
      required this.description,
      this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LanguageState currentLanguage = ref.watch(languageProvider);

    if (audioUrl.isEmpty) {
      return currentLanguage.toString() == "en"
          ? FlutterTtsSpeaker(text: description)
          : const SizedBox.shrink();
    }

    return FutureBuilder<bool>(
      future: isAudioUrlValid(audioUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AudioPlayerWidget(audioUrl: audioUrl);
        }

        final isValidAudio = snapshot.data ?? false;

        if (currentLanguage.toString() == "en") {
          return isValidAudio
              ? AudioPlayerWidget(
                  audioUrl: audioUrl,
                  data: data,
                )
              : FlutterTtsSpeaker(text: description);
        } else {
          return isValidAudio
              ? AudioPlayerWidget(
                  audioUrl: audioUrl,
                  data: data,
                )
              : const SizedBox.shrink();
        }
      },
    );
  }

  Future<bool> isAudioUrlValid(String audioUrl) async {
    if (audioUrl.isEmpty) return false;

    try {
      final response = await http.head(Uri.parse(audioUrl));
      return (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      return false;
    }
  }
}

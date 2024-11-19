import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/language_state.dart';
import 'package:gompa_tour/ui/widget/audio_player.dart';
import 'package:gompa_tour/ui/widget/flutter_tts_speaker.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String audioUrl;
  final String description;
  final String qrData;

  const DetailsScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.audioUrl,
    required this.description,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              SpeakerWidget(audioUrl: audioUrl, description: description),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Center(
              //   child: QrImage(
              //     data: qrData,
              //     version: QrVersions.auto,
              //     size: 200.0,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpeakerWidget extends ConsumerWidget {
  final String audioUrl;
  final String description;

  const SpeakerWidget(
      {super.key, required this.audioUrl, required this.description});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LanguageState currentLanguage = ref.watch(languageProvider);

    return currentLanguage.currentLanguage == "en"
        ? FlutterTtsSpeaker(
            text: description,
          )
        : AudioPlayerWidget(audioUrl: audioUrl);
  }
}

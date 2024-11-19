import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlutterTtsSpeaker extends StatefulWidget {
  final String text;

  const FlutterTtsSpeaker({
    super.key,
    required this.text,
  });

  @override
  State<FlutterTtsSpeaker> createState() => _FlutterTtsSpeakerState();
}

class _FlutterTtsSpeakerState extends State<FlutterTtsSpeaker> {
  late FlutterTts _flutterTts;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();

    // Configure TTS settings
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5); // Speed of speech
    await _flutterTts.setVolume(1.0); // Volume
    await _flutterTts.setPitch(1.0); // Pitch

    _flutterTts.setStartHandler(() {
      setState(() {
        _isPlaying = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  Future<void> _speak() async {
    if (widget.text.isEmpty) return;
    await _flutterTts.speak(widget.text);
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: IconButton.filled(
        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
        onPressed: _isPlaying ? _stop : _speak,
        tooltip: _isPlaying ? 'Pause' : 'Play',
      ),
    );
  }
}

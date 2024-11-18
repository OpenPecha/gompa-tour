import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

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
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Image.network(imageUrl),
              const SizedBox(height: 16),
              // AudioPlayerWidget(audioUrl: audioUrl),
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

// class AudioPlayerWidget extends StatefulWidget {
//   final String audioUrl;

//   AudioPlayerWidget({required this.audioUrl});

//   @override
//   _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
// }

// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   late AudioPlayer _audioPlayer;
//   bool isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     if (isPlaying) {
//       _audioPlayer.pause();
//     } else {
//       _audioPlayer.play(widget.audioUrl);
//     }
//     setState(() {
//       isPlaying = !isPlaying;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(
//           icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//           onPressed: _togglePlayPause,
//         ),
//         Text(isPlaying ? 'Pause' : 'Play'),
//       ],
//     );
//   }
// }

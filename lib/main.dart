import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gompa tour',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PilgrimageHome(),
    );
  }
}

class PilgrimageHome extends StatelessWidget {
  const PilgrimageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monastic Pilgrimage System'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // handle menu button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 12),
            const Text(
              'Explore Monastery Wonders on Your Pilgrimage.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Welcome to monastery tour!',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildCard(
              'Pilgrimage',
              'letters and sounds.',
              'assets/images/buddha.png',
            ),
            SizedBox(height: 16),
            _buildCard(
              'Organization',
              'letters, sounds and map.',
              'assets/images/potala2.png',
            ),
            SizedBox(height: 16),
            _buildCard(
              'Festival',
              'letters and sounds.',
              'assets/images/duchen.png',
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, String imagePath) {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.qr_code, color: Colors.white),
                Icon(Icons.map, color: Colors.white),
                Icon(Icons.search, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

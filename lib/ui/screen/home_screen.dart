import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCard(
            'Deties',
            'assets/images/buddha.png',
          ),
          const SizedBox(height: 16),
          _buildCard(
            'Gompa',
            'assets/images/potala2.png',
          ),
          const SizedBox(height: 16),
          _buildCard(
            'Festival',
            'assets/images/duchen.png',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String imagePath) {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 140,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

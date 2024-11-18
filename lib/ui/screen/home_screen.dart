import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/ui/screen/list_screen.dart';

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
            context,
          ),
          const SizedBox(height: 16),
          _buildCard(
            'Gompa',
            'assets/images/potala2.png',
            context,
          ),
          const SizedBox(height: 16),
          _buildCard(
            'Festival',
            'assets/images/duchen.png',
            context,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the list of items screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ListScreen(
              items: [
                Item(
                    title: 'ZhangzhungDrenpaNamkha',
                    description:
                        'ZhangzhungDrenpaNamkha was born to GrungyarMukhoe and ShazaGungzun at the silver palace of Garuda, Zhangzhung in 914 BCE.',
                    imgUrl:
                        'https://gompa-tour.s3.ap-south-1.amazonaws.com/media/images/1731301190TN977449.jpg'),
                Item(
                    title: 'Yellow Goddess Vasundra (Wealth-Granting Goddess)',
                    description:
                        ' The Yellow Goddess Vasundra has a yellow body with one face and two arms.',
                    imgUrl:
                        'https://gompa-tour.s3.ap-south-1.amazonaws.com/media/images/1730443713TN208873.jpg'),

                // Add more items here
              ],
            ),
          ),
        );
      },
      child: Card(
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
      ),
    );
  }
}

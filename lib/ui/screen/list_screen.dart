import 'package:flutter/material.dart';
import 'package:gompa_tour/ui/screen/details_screen.dart';

class ListScreen extends StatelessWidget {
  final List<Item> items;

  const ListScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Items'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the detail screen of the item
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    title: items[index].title,
                    imageUrl: items[index].imgUrl,
                    audioUrl:
                        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                    description: items[index].description,
                    qrData: items[index].title,
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 0),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[index].title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            items[index].imgUrl,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            items[index].description.substring(0, 50),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Item {
  final String title;
  final String description;
  final String imgUrl;

  Item({required this.title, required this.description, required this.imgUrl});
}

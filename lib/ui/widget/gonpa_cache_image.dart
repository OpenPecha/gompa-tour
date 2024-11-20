import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GonpaCacheImage extends StatelessWidget {
  final String? url;
  final double width;
  final double height;
  final BoxFit fit;
  const GonpaCacheImage(
      {super.key,
      this.url,
      this.width = double.infinity,
      this.height = 400,
      this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: fit,
      imageUrl: url ?? '',
      placeholder: (context, url) => const Center(
          child: SizedBox(
              width: 40, height: 40, child: CircularProgressIndicator())),
      errorWidget: (context, _, error) {
        // If the image URL is null or error occurs, load the asset image
        return url == null
            ? Image.asset(
                width: width,
                height: height,
                'assets/images/buddha.png') // Fallback asset image
            : const Icon(Icons.error);
      },
    );
  }
}

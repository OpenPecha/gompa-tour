import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helper/database_helper.dart';
import '../../util/util.dart';

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
    if (url == null) {
      return const Icon(Icons.error);
    } else if (!isValidUrl(url!)) {
      return SizedBox(
        width: width,
        height: height,
        child: FutureBuilder<bool>(
            future: _checkImageExist(url!),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData && snapshot.data == true) {
                return Image.asset(
                  'assets/${url!}',
                  width: width,
                  height: height,
                  fit: fit,
                  errorBuilder: (context, _, __) {
                    return const Icon(Icons.error);
                  },
                );
              } else {
                return SizedBox(
                    width: width,
                    height: height,
                    child: const Icon(Icons.error));
              }
            }),
      );
    } else {
      //https://gompa-tour.s3.ap-south-1.amazonaws.com/media/images/1731050441GP205582.jpg
      return CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        imageUrl: url ?? '',
        placeholder: (context, url) => const Center(
            child: SizedBox(
                width: 40, height: 40, child: CircularProgressIndicator())),
        errorWidget: (context, _, error) {
          if (url != null && url!.contains('media/')) {
            return Image.asset(
              'assets/${url!}',
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, _, __) {
                return const Icon(Icons.error);
              },
            );
          } else {
            return const Icon(Icons.error);
          }
        },
        errorListener: (value) {
          logger.severe('Error loading image: $value');
        },
      );
    }
  }

  Future<bool> _checkImageExist(String url) async {
    try {
      await rootBundle.load('assets/$url');
      return true;
    } catch (_) {
      logger.info("Image not found: $url");
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../config/constant.dart';

class GonpaQRCard extends StatelessWidget {
  final String slug;
  const GonpaQRCard({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 0.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.qr_code_scanner, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.scanQrCode,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: QrImageView(
                backgroundColor: Colors.white,
                data: kDetiesQrCodeBaseUrl + slug,
                version: QrVersions.auto,
                size: height / 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

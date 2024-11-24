import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/organization_model.dart';

class AddressCard extends StatelessWidget {
  final Organization address;
  const AddressCard({super.key, required this.address});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shadowColor: Theme.of(context).colorScheme.shadow,
          color: Theme.of(context).colorScheme.surfaceContainer,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.address,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (address.enTitle.isNotEmpty) ...[
                  Text(
                    'Name: ${context.localizedText(
                      enText: address.enTitle,
                      boText: address.tbTitle,
                    )}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (address.street.isNotEmpty) ...[
                  Text(
                    'Street: ${context.localizedText(
                      enText: address.street,
                      boText: address.street,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (address.address2.isNotEmpty) ...[
                  Text(
                    'Address 2: ${context.localizedText(
                      enText: address.address2,
                      boText: address.address2,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (address.state.isNotEmpty) ...[
                  Text(
                    'State: ${context.localizedText(
                      enText: address.state,
                      boText: address.state,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (address.postalCode.isNotEmpty) ...[
                  Text(
                    'Postal Code: ${context.localizedText(
                      enText: address.postalCode,
                      boText: address.postalCode,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (address.country.isNotEmpty) ...[
                  Text(
                    'Country: ${context.localizedText(
                      enText: address.country,
                      boText: address.country,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (address.phone.isNotEmpty) ...[
                  Text(
                    'Phone: ${context.localizedText(
                      enText: address.phone,
                      boText: address.phone,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (address.email.isNotEmpty) ...[
                  Text(
                    'Email: ${context.localizedText(
                      enText: address.email,
                      boText: address.email,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (address.web.isNotEmpty) ...[
                  Text(
                    'Web: ${address.web}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (address.map.isNotEmpty) ...[
                  Text(
                    'Map: ${address.map}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

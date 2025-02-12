import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gompa_tour/models/organization_model.dart';
import 'package:gompa_tour/models/pilgrim_site.dart';
import 'package:latlong2/latlong.dart';

import '../../config/constant.dart';

class LocationCard extends StatelessWidget {
  final Object address;
  const LocationCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final (lat, lng) = parseLatLng(address.map);
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.map, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.location,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height / 4,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(lat, lng),
                  initialZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate: kEsriMapUrl,
                    subdomains: const ['a', 'b', 'c'],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (double, double) parseLatLng(String map) {
    final parts = map.split(',');
    final latitude = double.parse(parts[0].trim());
    final longitude = double.parse(parts[1].trim());
    return (latitude, longitude);
  }
}

extension on Object {
  String get map => this is Organization
      ? (this as Organization).map
      : (this as PilgrimSite).geoLocation;
}

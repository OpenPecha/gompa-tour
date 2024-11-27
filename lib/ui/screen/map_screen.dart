import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/database_helper.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/organization_model.dart';
import 'package:gompa_tour/ui/screen/organization_detail_screen.dart';
import 'package:gompa_tour/ui/widget/country_marker.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:latlong2/latlong.dart';

import '../../config/constant.dart';
import '../../states/organization_state.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final MapController mapController;
  @override
  void initState() {
    ref.read(organizationNotifierProvider.notifier).fetchOrganizations();
    mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(mapController),
          _buildLocationPopup(),
        ],
      ),
    );
  }

  Widget _buildMap(
    MapController mapController,
  ) {
    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(
        initialCenter: LatLng(20.5937, 78.9629),
        initialZoom: 5,
        minZoom: 4,
      ),
      children: [
        GestureDetector(
          onTap: () {
            ref.read(selectedOrganizationProvider.notifier).state = null;
          },
          child: TileLayer(
            urlTemplate: kEsriMapUrl,
            subdomains: const ['a', 'b', 'c'],
          ),
        ),
        Consumer(
          builder: (_, ref, __) {
            final state = ref.watch(organizationNotifierProvider);
            logger.info("Organization:$state");
            return MarkerLayer(
              markers: [
                ...state.organizations
                    .where((location) => location.map.trim().isNotEmpty)
                    .map((location) => _buildMarker(location))
                    .toList(),
                ..._buildCountryMarker(),
              ],
            );
          },
        )
      ],
    );
  }

  Marker _buildMarker(
    Organization organization,
  ) {
    double lang = 0.0;
    double lat = 0.0;
    List<String> coordinates = organization.map.split(',');
    if (coordinates.length == 2) {
      double? latitude = double.tryParse(coordinates[0].trim());
      double? longitude = double.tryParse(coordinates[1].trim());
      if (latitude != null && longitude != null) {
        lang = latitude;
        lat = longitude;
      }
    }
    return Marker(
      point: LatLng(lang, lat),
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () => ref.read(selectedOrganizationProvider.notifier).state =
            organization,
        child: Image.asset('assets/images/marker-icon.png'),
      ),
    );
  }

  Widget _buildLocationPopup() {
    final selectedOrganization = ref.watch(selectedOrganizationProvider);

    if (selectedOrganization == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface,
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Hero(
                tag: selectedOrganization.id,
                child: GonpaCacheImage(
                  url: selectedOrganization.pic,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedOrganization.tbTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.localizedText(
                      enText: selectedOrganization.enContent,
                      boText: selectedOrganization.tbContent,
                      maxLength: kDescriptionMaxLength,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          ref
                              .read(selectedOrganizationProvider.notifier)
                              .state = selectedOrganization;
                          context.push(OrganizationDetailScreen.routeName);
                        },
                        child: Text(AppLocalizations.of(context)!.detail),
                      ),
                      TextButton(
                        onPressed: () => ref
                            .read(selectedOrganizationProvider.notifier)
                            .state = null,
                        child: Text(AppLocalizations.of(context)!.close),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCountryMarker() {
    // get and return india, bhutan and nepal coordinates
    final countries = [
      {
        'name': AppLocalizations.of(context)!.india,
        'coordinates': LatLng(20.5937, 78.9629),
      },
      {
        'name': AppLocalizations.of(context)!.bhutan,
        'coordinates': LatLng(27.5142, 90.4336),
      },
      {
        'name': AppLocalizations.of(context)!.nepal,
        'coordinates': LatLng(28.3949, 84.1240),
      },
    ];

    return countries.map((country) {
      return Marker(
        point: country['coordinates'] as LatLng,
        width: 40,
        height: 40,
        child: CountryMarker(country: country),
      );
    }).toList();
  }
}

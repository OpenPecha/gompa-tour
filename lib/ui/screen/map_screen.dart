import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/database_helper.dart';
import 'package:gompa_tour/models/organization_model.dart';
import 'package:gompa_tour/ui/screen/organization_detail_screen.dart';
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
            final organization = ref.watch(organizationNotifierProvider);
            logger.info("Organization:$organization");
            return MarkerLayer(
              markers: organization
                  .map((location) => _buildMarker(location))
                  .toList(),
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
              blurRadius: 10,
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
                  const Text(
                    'Some description',
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
                        child: const Text('Details'),
                      ),
                      TextButton(
                        onPressed: () => ref
                            .read(selectedOrganizationProvider.notifier)
                            .state = null,
                        child: const Text('Close'),
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
}

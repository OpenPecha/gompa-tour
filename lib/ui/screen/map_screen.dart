import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/helper/database_helper.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/gonpa.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/ui/screen/organization_detail_screen.dart';
import 'package:gompa_tour/ui/widget/country_marker.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:gompa_tour/util/translation_helper.dart';
import 'package:latlong2/latlong.dart';

import '../../config/constant.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final MapController mapController;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _fetchCurrentLocation();
    Future(() {
      ref.read(gonpaNotifierProvider.notifier).fetchAllGonpas();
    });
  }

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    print('serviceEnabled: $serviceEnabled');

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // Get the current position using the new `settings` parameter
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high, // High accuracy
        distanceFilter: 1000, // Minimum distance (in meters) to trigger updates
      ),
    );

    // Update the current location state
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      // Animate to the current location
      mapController.move(_currentLocation!, 10);
    });
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

  Widget _buildMap(MapController mapController) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: _currentLocation ?? LatLng(20.5937, 78.9629),
        initialZoom: _currentLocation != null ? 10 : 5,
        minZoom: 4,
        onMapReady: () {
          // Ensure map animates to current location if it's available when map is ready
          if (_currentLocation != null) {
            mapController.move(_currentLocation!, 10);
          }
        },
      ),
      children: [
        GestureDetector(
          onTap: () {
            ref.read(selectedGonpaProvider.notifier).state = null;
          },
          child: TileLayer(
            urlTemplate: kEsriMapUrl,
            subdomains: const ['a', 'b', 'c'],
          ),
        ),
        Consumer(
          builder: (_, ref, __) {
            final state = ref.watch(gonpaNotifierProvider);
            logger.info("Gonpa:$state ${state.gonpas.length}");
            return MarkerLayer(
              markers: [
                ...state.gonpas
                    .where((gonpa) => gonpa.geoLocation.trim().isNotEmpty)
                    .map((gonpa) => _buildMarker(gonpa)),
                ..._buildCountryMarker(),
                if (_currentLocation != null)
                  Marker(
                    point: _currentLocation!,
                    width: 20,
                    height: 20,
                    child: Icon(Icons.location_on, color: Colors.red[800]),
                  ),
              ],
            );
          },
        )
      ],
    );
  }

  Marker _buildMarker(
    Gonpa gonpa,
  ) {
    double lang = 0.0;
    double lat = 0.0;
    List<String> coordinates = gonpa.geoLocation.split(',');
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
        onTap: () => ref.read(selectedGonpaProvider.notifier).state = gonpa,
        child: Image.asset('assets/images/marker-icon.png'),
      ),
    );
  }

  Widget _buildLocationPopup() {
    final selectedGonpa = ref.watch(selectedGonpaProvider);

    if (selectedGonpa == null) return const SizedBox.shrink();

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
                tag: selectedGonpa.id,
                child: GonpaCacheImage(
                  url: selectedGonpa.image,
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
                    context.localizedText(
                      enText: TranslationHelper.getTranslatedField(
                          translations: selectedGonpa.translations,
                          languageCode: "en",
                          fieldGetter: (t) => t.name),
                      boText: TranslationHelper.getTranslatedField(
                          translations: selectedGonpa.translations,
                          languageCode: "bo",
                          fieldGetter: (t) => t.name),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: context.getLocalizedHeight(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      context.localizedText(
                        enText: TranslationHelper.getTranslatedField(
                            translations: selectedGonpa.translations,
                            languageCode: "en",
                            fieldGetter: (t) => t.description),
                        boText: TranslationHelper.getTranslatedField(
                            translations: selectedGonpa.translations,
                            languageCode: "bo",
                            fieldGetter: (t) => t.description),
                        maxLength: kDescriptionMaxLength,
                      ),
                      style: TextStyle(
                        height: context.getLocalizedHeight(),
                      )),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          ref.read(selectedGonpaProvider.notifier).state =
                              selectedGonpa;
                          context.push(OrganizationDetailScreen.routeName);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.detail,
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref
                            .read(selectedGonpaProvider.notifier)
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

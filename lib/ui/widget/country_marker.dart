import 'package:flutter/material.dart';

class CountryMarker extends StatefulWidget {
  final Map<String, dynamic> country;
  const CountryMarker({super.key, required this.country});

  @override
  State<CountryMarker> createState() => _CountryMarkerState();
}

class _CountryMarkerState extends State<CountryMarker> {
  final GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final dynamic tooltip = key.currentState;
        tooltip.ensureTooltipVisible();
      },
      child: Tooltip(
          key: key,
          message: widget.country['name'] as String,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Image.asset('assets/images/country.png')),
    );
  }
}

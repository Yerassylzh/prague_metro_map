import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/metro_data.dart';
import '../models/station.dart';
import '../models/station_detail.dart';
import '../services/translation_service.dart';

const _headerColor = Color(0xFF0077B6);
const _headerOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: _headerColor,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

class StationMapScreen extends StatelessWidget {
  final Station station;
  final StationDetail details;

  const StationMapScreen({
    super.key,
    required this.station,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = TranslationService().currentLanguage;
    final t = TranslationService().t;
    final stationName = station.getLocalizedName(langCode);
    final line = MetroData.getLine(station.lineId);
    final coordinates = StationCoordinates.tryParse(details.coordinates);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _headerOverlayStyle,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _headerColor,
          foregroundColor: Colors.white,
          systemOverlayStyle: _headerOverlayStyle,
          elevation: 0,
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stationName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (line != null)
                Text(
                  '${line.getLocalizedName(langCode)} (${line.number})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        body: coordinates == null
            ? _MissingCoordinatesMessage(message: t('map.coordinatesMissing'))
            : _StationMap(
                stationName: stationName,
                coordinates: coordinates,
              ),
      ),
    );
  }
}

class _StationMap extends StatelessWidget {
  final String stationName;
  final StationCoordinates coordinates;

  const _StationMap({
    required this.stationName,
    required this.coordinates,
  });

  @override
  Widget build(BuildContext context) {
    final center = LatLng(coordinates.latitude, coordinates.longitude);

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 16,
        minZoom: 11,
        maxZoom: 19,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.yerazh.prague_metro_map',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 160,
              height: 84,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: _headerColor),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      stationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _headerColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFFE53935),
                    size: 42,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MissingCoordinatesMessage extends StatelessWidget {
  final String message;

  const _MissingCoordinatesMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
            height: 1.35,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class StationCoordinates {
  static final _pattern = RegExp(
    r'(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)',
  );

  final double latitude;
  final double longitude;

  const StationCoordinates({
    required this.latitude,
    required this.longitude,
  });

  static StationCoordinates? tryParse(String? value) {
    if (value == null) return null;

    final match = _pattern.firstMatch(value);
    if (match == null) return null;

    final latitude = double.tryParse(match.group(1)!);
    final longitude = double.tryParse(match.group(2)!);
    if (latitude == null || longitude == null) return null;

    return StationCoordinates(latitude: latitude, longitude: longitude);
  }
}

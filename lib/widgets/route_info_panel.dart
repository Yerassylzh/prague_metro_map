import 'package:flutter/material.dart';
import '../models/route.dart';
import '../models/station.dart';
import '../services/translation_service.dart';

class RouteInfoPanel extends StatelessWidget {
  final MetroRoute route;
  final Station fromStation;
  final Station toStation;
  final VoidCallback onClear;

  const RouteInfoPanel({
    super.key,
    required this.route,
    required this.fromStation,
    required this.toStation,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final t = TranslationService();
    final langCode = t.currentLanguage;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.t('route.title'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.t('route.time', params: {'minutes': route.totalTime}),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.tPlural('route.transfers', route.transferCount),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStationRow(
              fromStation.getLocalizedName(langCode),
              Icons.trip_origin,
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildStationRow(
              toStation.getLocalizedName(langCode),
              Icons.place,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationRow(String name, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

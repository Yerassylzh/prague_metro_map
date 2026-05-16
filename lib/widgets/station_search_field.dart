import 'package:flutter/material.dart';
import '../models/station.dart';
import '../services/translation_service.dart';
import 'station_selector.dart';

class StationSearchField extends StatelessWidget {
  final String label;
  final Station? selectedStation;
  final Function(Station) onStationSelected;
  final Color iconColor;

  const StationSearchField({
    super.key,
    required this.label,
    this.selectedStation,
    required this.onStationSelected,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = TranslationService();
    final langCode = t.currentLanguage;

    return GestureDetector(
      onTap: () => _showSearchDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedStation?.getLocalizedName(langCode) ?? label,
                style: TextStyle(
                  color: selectedStation != null ? Colors.black : Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            if (selectedStation != null)
              GestureDetector(
                onTap: () => onStationSelected(selectedStation!),
                child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => StationSelector(
          title: label,
          selectedStation: selectedStation,
          onStationSelected: onStationSelected,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/metro_data.dart';
import '../models/line.dart';
import '../models/station.dart';
import '../services/translation_service.dart';

const _headerColor = Color(0xFF0077B6);
const _headerOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: _headerColor,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

class StationSelector extends StatefulWidget {
  final String title;
  final Station? selectedStation;
  final Function(Station) onStationSelected;

  const StationSelector({
    super.key,
    required this.title,
    this.selectedStation,
    required this.onStationSelected,
  });

  @override
  State<StationSelector> createState() => _StationSelectorState();
}

class _StationSelectorState extends State<StationSelector> {
  String _query = '';
  late final List<Station> _allStations;
  late final Map<String, MetroLine?> _lines;
  final FocusNode _focusNode = FocusNode();
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _allStations = MetroData.allStations;
    _lines = {};
    for (final line in MetroData.lines) {
      _lines[line.id] = line;
    }

    // Defer heavy rendering and keyboard popup to guarantee instant page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isReady = true);
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) _focusNode.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<Station> _getFilteredStations(String langCode) {
    if (_query.isEmpty) return _allStations;
    return MetroData.searchStations(_query, langCode);
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService();
    final langCode = t.currentLanguage;
    final stations = _getFilteredStations(langCode);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _headerOverlayStyle,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: _headerColor,
          systemOverlayStyle: _headerOverlayStyle,
          elevation: 0,
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: _headerColor,
              padding: const EdgeInsets.all(16),
              child: TextField(
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: t.t('search.placeholder'),
                  hintStyle:
                      const TextStyle(color: Colors.white70, fontSize: 16),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: _isReady
                  ? ListView.builder(
                      itemCount: stations.length,
                      itemBuilder: (context, index) {
                        final station = stations[index];
                        final isSelected =
                            widget.selectedStation?.id == station.id;
                        final line = _lines[station.lineId];

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: line?.color ?? Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            station.getLocalizedName(langCode),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            widget.onStationSelected(station);
                            Navigator.pop(context);
                          },
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: _headerColor),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

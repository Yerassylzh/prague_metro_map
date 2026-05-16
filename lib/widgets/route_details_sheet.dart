import 'package:flutter/material.dart';
import '../data/metro_data.dart';
import '../models/route.dart';
import '../models/station.dart';
import '../screens/station_detail_screen.dart';
import '../services/interstitial_ad_service.dart';
import '../services/translation_service.dart';
import 'station_search_field.dart';

class RouteDetailsSheet extends StatelessWidget {
  final Station? fromStation;
  final Station? toStation;
  final MetroRoute? route;
  final String? focusedLineId;
  final Function(Station) onFromSelected;
  final Function(Station) onToSelected;
  final VoidCallback onClear;
  final VoidCallback onLineClear;

  const RouteDetailsSheet({
    super.key,
    required this.fromStation,
    required this.toStation,
    required this.route,
    this.focusedLineId,
    required this.onFromSelected,
    required this.onToSelected,
    required this.onClear,
    required this.onLineClear,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasRoute = route != null;
    
    if (!hasRoute && focusedLineId != null) {
      return _buildLineDetails(context);
    }

    if (!hasRoute) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StationSearchField(
                    label: TranslationService().t('map.from'),
                    selectedStation: fromStation,
                    onStationSelected: onFromSelected,
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  StationSearchField(
                    label: TranslationService().t('map.to'),
                    selectedStation: toStation,
                    onStationSelected: onToSelected,
                    iconColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              
              // Scrollable content (Header + Timeline)
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    _buildCompactHeader(),
                    Container(
                      color: Colors.grey[50],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: _buildTimeline(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLineDetails(BuildContext context) {
    final line = MetroData.getLine(focusedLineId!);
    if (line == null) return const SizedBox.shrink();

    final langCode = TranslationService().currentLanguage;
    final stations = MetroData.getStationsOnLine(line.id);
    final textColor =
        line.color.computeLuminance() > 0.55 ? Colors.black87 : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.22,
      minChildSize: 0.18,
      maxChildSize: 0.9,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: stations.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: line.color,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${line.number}',
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  line.getLocalizedName(langCode),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: onLineClear,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final stationIndex = index - 1;
                      final station = stations[stationIndex];
                      final isFirst = stationIndex == 0;
                      final isLast = stationIndex == stations.length - 1;

                      return SizedBox(
                        height: 44,
                        child: Row(
                          children: [
                            _buildLineStationMarker(
                              line.color,
                              isFirst: isFirst,
                              isLast: isLast,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                station.getLocalizedName(langCode),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isFirst || isLast
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLineStationMarker(
    Color lineColor, {
    required bool isFirst,
    required bool isLast,
  }) {
    return SizedBox(
      width: 28,
      height: 44,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 4,
              color: isFirst ? Colors.transparent : lineColor,
            ),
          ),
          Container(
            width: isFirst || isLast ? 15 : 11,
            height: isFirst || isLast ? 15 : 11,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: lineColor,
                width: isFirst || isLast ? 4 : 3,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 4,
              color: isLast ? Colors.transparent : lineColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    final langCode = TranslationService().currentLanguage;
    final fromName = fromStation?.getLocalizedName(langCode) ?? '';
    final toName = toStation?.getLocalizedName(langCode) ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$fromName ➔ $toName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close, size: 24, color: Colors.black54),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  TranslationService().t('route.time', params: {'minutes': route!.totalTime.toString()}),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  TranslationService().tPlural('route.transfers', route!.transferCount),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTimeline() {
    final List<Widget> items = [];
    final langCode = TranslationService().currentLanguage;

    for (int i = 0; i < route!.segments.length; i++) {
      final segment = route!.segments[i];
      
      if (segment.isTransfer) {
        items.add(_buildTransferItem(segment));
      } else {
        items.add(_buildSegmentTimeline(segment, langCode));
      }
    }
    
    return items;
  }

  Widget _buildSegmentTimeline(RouteSegment segment, String langCode) {
    final line = MetroData.getLine(segment.lineId);
    if (line == null || segment.stationIds.isEmpty) return const SizedBox.shrink();

    final lineColor = line.color;
    final widgets = <Widget>[];

    for (int i = 0; i < segment.stationIds.length; i++) {
      final stationId = segment.stationIds[i];
      final station = MetroData.getStation(stationId);
      if (station == null) continue;

      final isFirst = i == 0;
      final isLast = i == segment.stationIds.length - 1;
      
      widgets.add(_buildRouteStationItem(
        station: station,
        lineColor: lineColor,
        isFirst: isFirst,
        isLast: isLast,
        langCode: langCode,
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  Widget _buildRouteStationItem({
    required Station station,
    required Color lineColor,
    required bool isFirst,
    required bool isLast,
    required String langCode,
  }) {
    return Builder(
      builder: (context) {
        return SizedBox(
          height: 52,
          child: Row(
            children: [
              _buildRouteStationMarker(
                lineColor,
                isFirst: isFirst,
                isLast: isLast,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  station.getLocalizedName(langCode),
                  style: TextStyle(
                    fontSize: (isFirst || isLast) ? 16 : 15,
                    fontWeight:
                        (isFirst || isLast) ? FontWeight.w800 : FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: 'Station info',
                visualDensity: VisualDensity.compact,
                onPressed: () => _openStationDetails(context, station),
                icon: const Icon(
                  Icons.info_outline,
                  size: 21,
                  color: Color(0xFF0077B6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRouteStationMarker(
    Color lineColor, {
    required bool isFirst,
    required bool isLast,
  }) {
    return SizedBox(
      width: 30,
      height: 52,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 4,
              color: isFirst ? Colors.transparent : lineColor,
            ),
          ),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: lineColor,
                width: (isFirst || isLast) ? 4 : 2,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 4,
              color: isLast ? Colors.transparent : lineColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openStationDetails(BuildContext context, Station station) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StationDetailScreen(station: station),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    await InterstitialAdService().recordStationInfoViewedAndMaybeShowAd();
  }

  Widget _buildTransferItem(RouteSegment segment) {
    final t = TranslationService().t;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_walk, size: 14, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    t('route.transfer'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '~ ${t('route.time', params: {'minutes': '2'})}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

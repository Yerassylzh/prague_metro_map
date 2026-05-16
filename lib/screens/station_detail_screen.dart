import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/metro_data.dart';
import '../data/station_details_data.dart';
import '../models/station_detail.dart';
import '../models/station.dart';
import '../services/translation_service.dart';
import '../widgets/ad_banner.dart';
import '../widgets/station_detail_section.dart';
import 'station_map_screen.dart';

const _headerColor = Color(0xFF0077B6);
const _headerOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: _headerColor,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({
    super.key,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = TranslationService().currentLanguage;
    final t = TranslationService().t;
    final line = MetroData.getLine(station.lineId);
    final details = stationDetails[station.id] ?? StationDetail.fallback;
    final exits = details.exits;
    final transport = details.nearbyTransport;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _headerOverlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F7FB),
        bottomNavigationBar: const BottomAdBanner(),
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
                station.getLocalizedName(langCode),
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
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
            children: [
              Center(
                child: OutlinedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StationMapScreen(
                          station: station,
                          details: details,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.black87, width: 1.4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    t('map.openInMaps'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (details.nearbyPlaces.isNotEmpty) ...[
                const SizedBox(height: 18),
                StationDetailSection(
                  title: t('station.interestingPlaces'),
                  children: [
                    Text(
                      details.nearbyPlaces
                          .map((place) => localizedText(place, langCode))
                          .join(', '),
                      style: StationDetailTextStyles.body,
                    ),
                  ],
                ),
              ] else
                const SizedBox(height: 18),
              StationDetailSection(
                title: t('station.exits'),
                children: exits.isEmpty
                    ? [
                        Text(
                          t('station.exitDataMissing'),
                          style: StationDetailTextStyles.body,
                        ),
                      ]
                    : [
                        for (final exit in exits)
                          LabeledDetailText(
                            label: localizedText(exit.location, langCode),
                            text: localizedText(exit.details, langCode),
                          ),
                      ],
              ),
              StationDetailSection(
                title: t('station.surfaceTransport'),
                children: [
                  if (transport.buses.isNotEmpty)
                    LabeledDetailText(
                      label: t('station.buses'),
                      text: transport.buses.join(', '),
                    ),
                  if (transport.trolleybuses.isNotEmpty)
                    LabeledDetailText(
                      label: t('station.trolleybuses'),
                      text: transport.trolleybuses.join(', '),
                    ),
                  if (transport.trams.isNotEmpty)
                    LabeledDetailText(
                      label: t('station.trams'),
                      text: transport.trams.join(', '),
                    ),
                  if (transport.other.isNotEmpty)
                    for (final item in transport.other)
                      Text(
                        localizedText(item, langCode),
                        style: StationDetailTextStyles.body,
                      ),
                  if (transport.isEmpty)
                    Text(
                      t('station.transportDataMissing'),
                      style: StationDetailTextStyles.body,
                    ),
                ],
              ),
              if (details.notes.isNotEmpty)
                StationDetailSection(
                  title: t('station.notes'),
                  children: [
                    for (final note in details.notes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '- ${localizedText(note, langCode)}',
                          style: StationDetailTextStyles.body,
                        ),
                      ),
                  ],
                ),
              if (details.coordinates != null)
                StationDetailSection(
                  title: t('station.coordinates'),
                  children: [
                    Text(
                      details.coordinates!,
                      style: StationDetailTextStyles.body,
                    ),
                  ],
                ),
              StationDetailSection(
                title: t('station.sources'),
                children: [
                  Text(
                    '${t('station.confidence')}: ${localizedText(details.confidence, langCode)}',
                    style: StationDetailTextStyles.body,
                  ),
                  Text(
                    '${t('station.verified')}: ${details.verifiedDate}',
                    style: StationDetailTextStyles.body,
                  ),
                  const SizedBox(height: 4),
                  for (final source in details.sources)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        source,
                        style: StationDetailTextStyles.source,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

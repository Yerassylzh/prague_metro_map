typedef LocalizedText = Map<String, String>;

String localizedText(LocalizedText text, String languageCode) {
  if (text.isEmpty) return '';
  return text[languageCode] ?? text['en'] ?? text.values.first;
}

class StationDetail {
  final List<StationExit> exits;
  final List<LocalizedText> nearbyPlaces;
  final NearbyTransport nearbyTransport;
  final String? coordinates;
  final List<LocalizedText> notes;
  final List<String> sources;
  final String verifiedDate;
  final LocalizedText confidence;

  const StationDetail({
    this.exits = const [],
    this.nearbyPlaces = const [],
    this.nearbyTransport = const NearbyTransport(),
    this.coordinates,
    this.notes = const [],
    this.sources = const [],
    this.verifiedDate = 'not verified',
    this.confidence = const {
      'en': 'unknown',
      'ru': 'неизвестно',
      'cs': 'nezname',
    },
  });

  static const fallback = StationDetail(
    notes: [
      {
        'en': 'Station detail data has not been added for this station yet.',
        'ru': 'Данные об этой станции пока не добавлены.',
        'cs': 'Udaje o teto stanici zatim nebyly pridany.',
      },
    ],
  );
}

class StationExit {
  final LocalizedText location;
  final LocalizedText details;

  const StationExit({
    required this.location,
    required this.details,
  });
}

class NearbyTransport {
  final List<String> buses;
  final List<String> trolleybuses;
  final List<String> trams;
  final List<LocalizedText> other;

  const NearbyTransport({
    this.buses = const [],
    this.trolleybuses = const [],
    this.trams = const [],
    this.other = const [],
  });

  bool get isEmpty =>
      buses.isEmpty && trolleybuses.isEmpty && trams.isEmpty && other.isEmpty;
}

class Station {
  final String id;
  final Map<String, String> name;
  final String lineId;
  final double x;
  final double y;
  final List<String> transferTo;
  final StationDetails? details;

  Station({
    required this.id,
    required this.name,
    required this.lineId,
    required this.x,
    required this.y,
    this.transferTo = const [],
    this.details,
  });

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? name.values.first;
  }

  bool get isTransfer => transferTo.isNotEmpty;
}

class StationDetails {
  final List<String> exits;
  final List<String> nearbyPlaces;
  final TransportInfo? transport;
  final ScheduleInfo? schedule;

  StationDetails({
    this.exits = const [],
    this.nearbyPlaces = const [],
    this.transport,
    this.schedule,
  });
}

class TransportInfo {
  final List<String> buses;
  final List<String> trolleybuses;

  TransportInfo({
    this.buses = const [],
    this.trolleybuses = const [],
  });
}

class ScheduleInfo {
  final String firstTrainWeekday;
  final String firstTrainSaturday;
  final String firstTrainSunday;
  final String lastTrainWeekday;
  final String lastTrainSaturday;
  final String lastTrainSunday;
  final Map<String, String> intervals;

  ScheduleInfo({
    required this.firstTrainWeekday,
    required this.firstTrainSaturday,
    required this.firstTrainSunday,
    required this.lastTrainWeekday,
    required this.lastTrainSaturday,
    required this.lastTrainSunday,
    required this.intervals,
  });
}

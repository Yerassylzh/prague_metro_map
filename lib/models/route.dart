class MetroRoute {
  final List<RouteSegment> segments;
  final int totalTime;
  final int transferCount;

  MetroRoute({
    required this.segments,
    required this.totalTime,
    required this.transferCount,
  });

  List<String> get stationIds => segments.expand((s) => s.stationIds).toList();
  List<String> get lineIds => segments.map((s) => s.lineId).toSet().toList();
}

class RouteSegment {
  final String lineId;
  final List<String> stationIds;
  final bool isTransfer;
  final String? fromStationId;
  final String? toStationId;

  RouteSegment({
    required this.lineId,
    required this.stationIds,
    this.isTransfer = false,
    this.fromStationId,
    this.toStationId,
  });
}

import '../models/route.dart';
import '../data/metro_data.dart';

class RouteService {
  static const int _stationTravelTime = 2;
  static const int _transferTime = 3;

  static MetroRoute? findRoute(String fromStationId, String toStationId) {
    if (fromStationId == toStationId) {
      return MetroRoute(
        segments: [],
        totalTime: 0,
        transferCount: 0,
      );
    }

    final result = _findShortestPath(fromStationId, toStationId);
    if (result == null) return null;

    final segments = _buildSegments(result.path);
    final totalTime = _calculateTotalTime(segments);
    final transferCount = segments.where((s) => s.isTransfer).length;

    return MetroRoute(
      segments: segments,
      totalTime: totalTime,
      transferCount: transferCount,
    );
  }

  static _PathResult? _findShortestPath(String start, String end) {
    final distances = <String, int>{};
    final previous = <String, String?>{};
    final unvisited = <String>{};

    for (final stationId in MetroData.stations.keys) {
      distances[stationId] = 999999;
      previous[stationId] = null;
      unvisited.add(stationId);
    }

    distances[start] = 0;

    while (unvisited.isNotEmpty) {
      String? current;
      int minDistance = 999999;

      for (final stationId in unvisited) {
        if (distances[stationId]! < minDistance) {
          minDistance = distances[stationId]!;
          current = stationId;
        }
      }

      if (current == null || current == end) break;
      unvisited.remove(current);

      final neighbors = _getNeighbors(current);
      for (final neighbor in neighbors) {
        if (!unvisited.contains(neighbor)) continue;

        final alt = distances[current]! + 1;
        if (alt < distances[neighbor]!) {
          distances[neighbor] = alt;
          previous[neighbor] = current;
        }
      }
    }

    if (previous[end] == null && start != end) return null;

    final path = <String>[];
    var current = end;
    while (current != start) {
      path.add(current);
      current = previous[current]!;
    }
    path.add(start);
    path.reverse();

    return _PathResult(path: path);
  }

  static List<String> _getNeighbors(String stationId) {
    final station = MetroData.getStation(stationId);
    if (station == null) return [];

    final neighbors = <String>[];

    final line = MetroData.getLine(station.lineId);
    if (line != null) {
      final index = line.stationIds.indexOf(stationId);
      if (index > 0) neighbors.add(line.stationIds[index - 1]);
      if (index < line.stationIds.length - 1) {
        neighbors.add(line.stationIds[index + 1]);
      }
    }

    neighbors.addAll(station.transferTo);

    return neighbors.toSet().toList();
  }

  static List<RouteSegment> _buildSegments(List<String> path) {
    final segments = <RouteSegment>[];
    if (path.length < 2) return segments;

    String currentLine = MetroData.getStation(path[0])!.lineId;
    var currentSegmentStations = <String>[path[0]];

    for (int i = 1; i < path.length; i++) {
      final station = MetroData.getStation(path[i])!;
      final prevStation = MetroData.getStation(path[i - 1])!;

      if (station.lineId != currentLine) {
        segments.add(RouteSegment(
          lineId: currentLine,
          stationIds: List.from(currentSegmentStations),
        ));

        segments.add(RouteSegment(
          lineId: '',
          stationIds: [prevStation.id, station.id],
          isTransfer: true,
          fromStationId: prevStation.id,
          toStationId: station.id,
        ));

        // New segment starts fresh with the first station of the new line.
        // Do NOT call add() below — station.id is already the seed.
        currentLine = station.lineId;
        currentSegmentStations = [station.id];
      } else {
        currentSegmentStations.add(station.id);
      }
    }

    segments.add(RouteSegment(
      lineId: currentLine,
      stationIds: List.from(currentSegmentStations),
    ));

    return segments;
  }

  static int _calculateTotalTime(List<RouteSegment> segments) {
    int time = 0;
    for (final segment in segments) {
      if (segment.isTransfer) {
        time += _transferTime;
      } else {
        time += (segment.stationIds.length - 1) * _stationTravelTime;
      }
    }
    return time;
  }
}

class _PathResult {
  final List<String> path;
  _PathResult({required this.path});
}

extension on List<String> {
  void reverse() {
    final length = this.length;
    for (int i = 0; i < length ~/ 2; i++) {
      final temp = this[i];
      this[i] = this[length - 1 - i];
      this[length - 1 - i] = temp;
    }
  }
}

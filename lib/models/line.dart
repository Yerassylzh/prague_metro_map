import 'package:flutter/material.dart';

class PathNode {
  final String? stationId;
  final double? dx;
  final double? dy;

  const PathNode.station(this.stationId)
      : dx = null,
        dy = null;

  const PathNode.point(this.dx, this.dy) : stationId = null;

  bool get isStation => stationId != null;
}

class MetroLine {
  final String id;
  final String number;
  final Map<String, String> name;
  final Color color;
  final List<String> stationIds; // Used for logical routing
  final List<PathNode> path; // Used for visual drawing

  MetroLine({
    required this.id,
    required this.number,
    required this.name,
    required this.color,
    required this.stationIds,
    this.path = const [],
  });

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? name.values.first;
  }
}

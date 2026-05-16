import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../data/metro_data.dart';
import '../models/line.dart';
import '../models/route.dart';
import '../models/station.dart';

/// Constants shared across drawing operations.
class _DrawConfig {
  // Metro line
  static const double lineStrokeWidth = 5.0;

  static const double routeBorderWidth = 10.0;
  static const double routeLineWidth = 8.0;

  // Transfer walk connections (dashed)
  static const double transferStrokeWidth = 3.0;
  static const double transferRouteStrokeWidth = 4.0;
  static const double transferMarkerRadius = 4.0;

  // Dash pattern (in canvas logical pixels)
  static const double dashLength = 14.0;
  static const double gapLength = 10.0;


}

/// Renders the interactive schematic metro map using a [CustomPainter].
///
/// Drawing order (back to front):
///   1. All metro lines (faded when route is active)
///   2. All transfer walk connections (gray dashed)
///   3. Route metro segments (solid orange, if route active)
///   4. Route transfer segments (dashed orange, on top of everything)
class MetroMapPainter extends CustomPainter {
  final Station? fromStation;
  final Station? toStation;
  final MetroRoute? route;
  final String? focusedLineId;
  final double mapWidth;
  final double mapHeight;
  final double leftMargin;
  final double topMargin;

  const MetroMapPainter({
    this.fromStation,
    this.toStation,
    this.route,
    this.focusedLineId,
    required this.mapWidth,
    required this.mapHeight,
    required this.leftMargin,
    required this.topMargin,
  });

  // ---------------------------------------------------------------------------
  // Coordinate helpers
  // ---------------------------------------------------------------------------

  double _getX(double normalizedX) => leftMargin + normalizedX * mapWidth;
  double _getY(double normalizedY) => topMargin + normalizedY * mapHeight;

  Offset _stationOffset(Station s) => Offset(_getX(s.x), _getY(s.y));

  // ---------------------------------------------------------------------------
  // Entry point
  // ---------------------------------------------------------------------------

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in MetroData.lines) {
      _drawMetroLine(canvas, line);
    }

    _drawTransferLines(canvas);

    if (route != null) {
      _drawRouteHighlight(canvas);
    }

    // Draw hubs on top of everything
    _drawTransferHubs(canvas);
  }

  @override
  bool shouldRepaint(covariant MetroMapPainter old) =>
      old.route != route ||
      old.focusedLineId != focusedLineId ||
      old.fromStation != fromStation ||
      old.toStation != toStation;

  void _drawTransferHubs(Canvas canvas) {
    final drawnPairs = <String>{};

    for (final station in MetroData.allStations) {
      if (station.transferTo.isEmpty) continue;

      for (final transferId in station.transferTo) {
        final pairKey = _pairKey(station.id, transferId);
        if (drawnPairs.contains(pairKey)) continue;
        drawnPairs.add(pairKey);

        final transferStation = MetroData.getStation(transferId);
        if (transferStation == null) continue;

        final from = _stationOffset(station);
        final to = _stationOffset(transferStation);

        if ((from - to).distance < 1.0) {
          final line1 = MetroData.getLine(station.lineId);
          final line2 = MetroData.getLine(transferStation.lineId);
          if (line1 == null || line2 == null) continue;

          bool isDimmed1 = false;
          bool isDimmed2 = false;
          if (route != null) {
            isDimmed1 = !route!.stationIds.contains(station.id);
            isDimmed2 = !route!.stationIds.contains(transferId);
          } else if (focusedLineId != null) {
            isDimmed1 = station.lineId != focusedLineId;
            isDimmed2 = transferStation.lineId != focusedLineId;
          }

          _drawHubMarker(canvas, from, line1.color, line2.color,
              isDimmed1: isDimmed1, isDimmed2: isDimmed2);
        }
      }
    }
  }

  void _drawHubMarker(Canvas canvas, Offset center, Color color1, Color color2,
      {required bool isDimmed1, required bool isDimmed2}) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4); // 45 degrees

    // Create a capsule (pill) shape
    const double radius = 12.0;
    const double offset = 8.0; // Half the distance between the two circles
    const double width = (offset * 2) + (radius * 2); // 24.0
    const double height = radius * 2; // 14.0

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: width, height: height),
      const Radius.circular(radius),
    );

    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw solid white capsule to mask the intersecting lines
    canvas.drawRRect(rect, bgPaint);

    final c1 = const Offset(-offset, 0); // left circle
    final c2 = const Offset(offset, 0); // right circle

    final border1 = Paint()
      ..color = isDimmed1 ? Colors.grey[300]! : color1
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final border2 = Paint()
      ..color = isDimmed2 ? Colors.grey[300]! : color2
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw interlocking rings
    canvas.drawCircle(c1, radius, border1);
    canvas.drawCircle(c2, radius, border2);

    canvas.restore();
  }

  // ---------------------------------------------------------------------------
  // Metro line drawing
  // ---------------------------------------------------------------------------

  void _drawMetroLine(Canvas canvas, MetroLine line) {
    if (line.path.length < 2) return;

    final opacity = _lineOpacity(line.id);
    final paint = Paint()
      ..color = line.color.withValues(alpha: opacity)
      ..strokeWidth = _DrawConfig.lineStrokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < line.path.length; i++) {
      final p = _getOffset(line.path[i]);
      if (p == null) continue;
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  Offset? _getOffset(PathNode node) {
    if (node.isStation) {
      final station = MetroData.getStation(node.stationId!);
      if (station == null) return null;
      return _stationOffset(station);
    } else {
      return Offset(_getX(node.dx!), _getY(node.dy!));
    }
  }

  double _lineOpacity(String lineId) {
    if (route == null && focusedLineId == null) return 1.0;
    if (route == null && focusedLineId != null) {
      return lineId == focusedLineId ? 1.0 : 0.15;
    }
    if (route!.lineIds.contains(lineId)) return 0.3;
    return 0.15;
  }

  // ---------------------------------------------------------------------------
  // Transfer walk lines (gray dashed, always shown)
  // ---------------------------------------------------------------------------

  void _drawTransferLines(Canvas canvas) {
    final routeTransferPairs = _buildRouteTransferPairs();

    // Track which pairs have already been drawn to avoid double-drawing.
    // Double-drawing from opposite ends fills each other's gaps → looks solid.
    final drawnPairs = <String>{};

    final linePaint = Paint()
      ..strokeWidth = _DrawConfig.transferStrokeWidth
      ..style = PaintingStyle.stroke;

    final markerPaint = Paint()..style = PaintingStyle.fill;

    for (final station in MetroData.allStations) {
      if (station.transferTo.isEmpty) continue;

      for (final transferId in station.transferTo) {
        final transferStation = MetroData.getStation(transferId);
        if (transferStation == null) continue;

        final pairKey = _pairKey(station.id, transferId);

        // Skip if this pair was already drawn from the other direction.
        if (drawnPairs.contains(pairKey)) continue;
        drawnPairs.add(pairKey);

        // Route transfers are drawn by _drawRouteHighlight; skip here.
        if (route != null && routeTransferPairs.contains(pairKey)) continue;

        final from = _stationOffset(station);
        final to = _stationOffset(transferStation);

        final isDimmedByFocus = focusedLineId != null &&
            station.lineId != focusedLineId &&
            transferStation.lineId != focusedLineId;
        final color = route != null || isDimmedByFocus
            ? Colors.grey[300]!
            : Colors.grey[600]!;
        linePaint.color = color;
        markerPaint.color = color;

        _drawDashedLine(canvas, from, to, linePaint);
        canvas.drawCircle(from, _DrawConfig.transferMarkerRadius, markerPaint);
        canvas.drawCircle(to, _DrawConfig.transferMarkerRadius, markerPaint);
      }
    }
  }

  /// Returns the sorted pair key set for all transfer segments in the route.
  Set<String> _buildRouteTransferPairs() {
    if (route == null) return {};
    return {
      for (final seg in route!.segments)
        if (seg.isTransfer && seg.stationIds.length >= 2)
          _pairKey(seg.stationIds[0], seg.stationIds[1]),
    };
  }

  /// Canonical sorted key so A↔B and B↔A map to the same string.
  String _pairKey(String a, String b) {
    final sorted = [a, b]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // ---------------------------------------------------------------------------
  // Route highlight (orange)
  // ---------------------------------------------------------------------------

  void _drawRouteHighlight(Canvas canvas) {
    if (route == null) return;

    // Pass 1 — solid metro segments (drawn first / underneath)
    _drawRouteMetroSegments(canvas);

    // Pass 2 — dashed transfer segments (drawn on top)
    _drawRouteTransferSegments(canvas);
  }

  void _drawRouteMetroSegments(Canvas canvas) {
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = _DrawConfig.routeBorderWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..strokeWidth = _DrawConfig.routeLineWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final segment in route!.segments) {
      if (segment.isTransfer) continue;
      final line = MetroData.getLine(segment.lineId);
      if (line == null) continue;

      linePaint.color = line.color;

      if (segment.stationIds.length < 2) continue;

      for (int i = 0; i < segment.stationIds.length - 1; i++) {
        final fromId = segment.stationIds[i];
        final toId = segment.stationIds[i + 1];

        final pathNodes = _getPathSegment(line, fromId, toId);
        if (pathNodes.length < 2) continue;

        final path = Path();
        bool started = false;
        for (int j = 0; j < pathNodes.length; j++) {
          final p = _getOffset(pathNodes[j]);
          if (p == null) continue;
          if (!started) {
            path.moveTo(p.dx, p.dy);
            started = true;
          } else {
            path.lineTo(p.dx, p.dy);
          }
        }

        canvas.drawPath(path, borderPaint);
        canvas.drawPath(path, linePaint);
      }
    }
  }

  List<PathNode> _getPathSegment(MetroLine line, String fromId, String toId) {
    int start = line.path.indexWhere((n) => n.stationId == fromId);
    int end = line.path.indexWhere((n) => n.stationId == toId);
    if (start == -1 || end == -1) return [];

    if (start <= end) {
      return line.path.sublist(start, end + 1);
    } else {
      return line.path.sublist(end, start + 1).reversed.toList();
    }
  }

  void _drawRouteTransferSegments(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = _DrawConfig.transferRouteStrokeWidth
      ..style = PaintingStyle.stroke;

    for (final segment in route!.segments) {
      if (!segment.isTransfer) continue;

      final stations = _resolveStations(segment.stationIds);
      if (stations.length < 2) continue;

      for (int i = 0; i < stations.length - 1; i++) {
        final from = _stationOffset(stations[i]);
        final to = _stationOffset(stations[i + 1]);
        _drawDashedLine(canvas, from, to, paint);
      }
    }
  }

  List<Station> _resolveStations(List<String> ids) {
    return ids.map(MetroData.getStation).whereType<Station>().toList();
  }

  // ---------------------------------------------------------------------------
  // Dashed line primitive
  // ---------------------------------------------------------------------------

  /// Draws a dashed line from [start] to [end].
  ///
  /// Always uses [StrokeCap.butt] internally — round caps add painted area
  /// beyond each dash endpoint, eating into gaps and making lines look solid.
  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final delta = end - start;
    final distance = delta.distance;
    if (distance == 0) return;

    final dashedPaint = Paint()
      ..color = paint.color
      ..strokeWidth = paint.strokeWidth
      ..strokeCap = StrokeCap.butt    // flat ends — no cap overshoot into gap
      ..style = PaintingStyle.stroke;

    final direction = delta / distance; // unit vector

    double traveled = 0.0;
    bool drawing = true;

    while (traveled < distance) {
      final segLen = drawing ? _DrawConfig.dashLength : _DrawConfig.gapLength;
      final segEnd = math.min(traveled + segLen, distance);

      if (drawing) {
        final p1 = start + direction * traveled;
        final p2 = start + direction * segEnd;
        canvas.drawLine(p1, p2, dashedPaint);
      }

      traveled = segEnd;
      drawing = !drawing;
    }
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../data/metro_data.dart';
import '../models/line.dart';
import '../models/route.dart';
import '../models/station.dart';
import '../painters/metro_map_painter.dart';
import '../services/translation_service.dart';

class MetroMap extends StatefulWidget {
  final Station? fromStation;
  final Station? toStation;
  final MetroRoute? route;
  final String? focusedLineId;
  final Function(Station) onStationSelected;
  final Function(String) onLineSelected;

  const MetroMap({
    super.key,
    this.fromStation,
    this.toStation,
    this.route,
    this.focusedLineId,
    required this.onStationSelected,
    required this.onLineSelected,
  });

  @override
  State<MetroMap> createState() => _MetroMapState();
}

class _MetroMapState extends State<MetroMap> {
  // Map canvas dimensions in logical pixels
  static const double _mapWidth = 900.0;
  static const double _mapHeight = 1100.0;
  static const double _leftMargin = 120.0;
  static const double _topMargin = 80.0;
  static const double _initialScale = 0.5;
  static const double _minScale = _initialScale;

  late final TransformationController _transformationController;
  bool _isClampingTransform = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController()
      ..value = _scaleMatrix(_initialScale);
    _transformationController.addListener(_enforceMinScale);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_enforceMinScale);
    _transformationController.dispose();
    super.dispose();
  }

  static Matrix4 _scaleMatrix(double scale) {
    return Matrix4.diagonal3Values(scale, scale, 1.0);
  }

  void _enforceMinScale() {
    if (_isClampingTransform) return;

    final value = _transformationController.value;
    final scale = _currentMapScale(value);
    if (scale >= _minScale) return;

    final clamped = _clampMatrixToMinScale(value);

    _isClampingTransform = true;
    _transformationController.value = clamped;
    _isClampingTransform = false;
  }

  Matrix4 _clampMatrixToMinScale(Matrix4 value) {
    final currentScale = _currentMapScale(value);
    if (currentScale <= 0) return _scaleMatrix(_minScale);

    final factor = _minScale / currentScale;
    final clamped = Matrix4.copy(value);
    final storage = clamped.storage;

    // Preserve the current pan offset, but scale every basis component back
    // up to the minimum. This prevents pinch gestures from sneaking below
    // the app's opening zoom level.
    storage[0] *= factor;
    storage[1] *= factor;
    storage[2] *= factor;
    storage[4] *= factor;
    storage[5] *= factor;
    storage[6] *= factor;
    storage[8] *= factor;
    storage[9] *= factor;
    storage[10] = 1.0;

    return clamped;
  }

  double _currentMapScale(Matrix4 value) {
    final storage = value.storage;
    final xScale = math.sqrt(storage[0] * storage[0] + storage[1] * storage[1]);
    final yScale = math.sqrt(storage[4] * storage[4] + storage[5] * storage[5]);
    return math.max(xScale, yScale);
  }

  double _getX(double nx) => _leftMargin + nx * _mapWidth;
  double _getY(double ny) => _topMargin + ny * _mapHeight;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(500),
      minScale: _minScale,
      maxScale: 5.0,
      constrained: false,
      transformationController: _transformationController,
      onInteractionUpdate: (_) => _enforceMinScale(),
      onInteractionEnd: (_) => _enforceMinScale(),
      child: SizedBox(
        width: _mapWidth + 600,
        height: _mapHeight + 600,
        child: CustomPaint(
          painter: MetroMapPainter(
            fromStation: widget.fromStation,
            toStation: widget.toStation,
            route: widget.route,
            focusedLineId: widget.focusedLineId,
            mapWidth: _mapWidth,
            mapHeight: _mapHeight,
            leftMargin: _leftMargin,
            topMargin: _topMargin,
          ),
          child: Stack(
            children: [..._buildStationButtons(), ..._buildLineBadges()],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Station buttons (overlaid on top of the canvas)
  // ---------------------------------------------------------------------------

  List<Widget> _buildStationButtons() {
    final routeIds = widget.route?.stationIds ?? [];
    final focusedLine = widget.focusedLineId;
    final buttons = <Widget>[];

    for (final station in MetroData.allStations) {
      buttons.add(_buildStationDot(station, routeIds, focusedLine));
      buttons.add(_buildStationLabel(station, routeIds, focusedLine));
    }

    return buttons;
  }

  Widget _buildStationDot(
    Station station,
    List<String> routeIds,
    String? focusedLineId,
  ) {
    final isFrom = widget.fromStation?.id == station.id;
    final isTo = widget.toStation?.id == station.id;
    final isOnRoute = routeIds.contains(station.id);
    final isOnFocusedLine =
        focusedLineId == null || station.lineId == focusedLineId;
    final isDimmed =
        (widget.route != null && !isOnRoute) ||
        (widget.route == null && focusedLineId != null && !isOnFocusedLine);
    final isTransfer = station.transferTo.isNotEmpty;

    const tapSize = 48.0;
    const borderWidth = 3.0;
    final dotSize = isFrom || isTo ? 24.0 : (isTransfer ? 20.0 : 16.0);

    final dotColor = isTransfer && !isFrom && !isTo
        ? Colors.transparent
        : (isDimmed
              ? Colors.grey[400]!
              : _stationDotColor(station, isFrom, isTo));

    final borderColor = isTransfer && !isFrom && !isTo
        ? Colors.transparent
        : (isDimmed ? Colors.grey[300]! : Colors.white);

    return Positioned(
      left: _getX(station.x) - tapSize / 2,
      top: _getY(station.y) - tapSize / 2,
      child: GestureDetector(
        onTap: () => widget.onStationSelected(station),
        child: SizedBox(
          width: tapSize,
          height: tapSize,
          child: Center(
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: isFrom || isTo
                  ? Center(
                      child: Icon(
                        isFrom ? Icons.trip_origin : Icons.place,
                        color: Colors.white,
                        size: 10,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStationLabel(
    Station station,
    List<String> routeIds,
    String? focusedLineId,
  ) {
    final langCode = TranslationService().currentLanguage;
    final isOnRoute = routeIds.contains(station.id);
    final isOnFocusedLine =
        focusedLineId == null || station.lineId == focusedLineId;
    final isDimmed =
        (widget.route != null && !isOnRoute) ||
        (widget.route == null && focusedLineId != null && !isOnFocusedLine);
    final pos = _getLabelPosition(station);
    final rotation = _labelRotation(pos);

    // Gap from the center of the station dot to the start of the text.
    // Rotated labels need more clearance because their transformed bounds can
    // otherwise sweep back over the station marker or the line segment.
    final gap = _labelGap(pos);

    Widget labelText = Text(
      station.getLocalizedName(langCode),
      style: TextStyle(
        fontSize: 13,
        fontWeight: isOnRoute || station.lineId == focusedLineId
            ? FontWeight.w700
            : FontWeight.w500,
        color: isDimmed ? Colors.grey[500]! : Colors.black87,
        height: 1.1,
      ),
      textAlign: pos == LabelPosition.left ? TextAlign.right : TextAlign.left,
    );

    double? left, top;
    Offset translation = Offset.zero;

    switch (pos) {
      case LabelPosition.right:
        left = _getX(station.x) + gap;
        top = _getY(station.y);
        translation = const Offset(0, -0.5); // perfectly center vertically
        break;
      case LabelPosition.left:
        left = _getX(station.x) - gap;
        top = _getY(station.y);
        translation = const Offset(
          -1.0,
          -0.5,
        ); // shift left by 100% width, center vertically
        break;
      case LabelPosition.top:
        left = _getX(station.x);
        top = _getY(station.y) - gap;
        translation = const Offset(
          -0.5,
          -1.0,
        ); // center horizontally, shift up by 100% height
        break;
      case LabelPosition.bottom:
        left = _getX(station.x);
        top = _getY(station.y) + gap;
        translation = const Offset(-0.5, 0.0); // center horizontally, below dot
        break;
      case LabelPosition.topLeft:
        left = _getX(station.x) - gap;
        top = _getY(station.y) - gap;
        translation = const Offset(-1.0, -1.0);
        break;
      case LabelPosition.topRight:
        left = _getX(station.x) + gap;
        top = _getY(station.y) - gap;
        translation = const Offset(0.0, -1.0);
        break;
      case LabelPosition.bottomLeft:
        left = _getX(station.x) - gap;
        top = _getY(station.y) + gap;
        translation = const Offset(-1.0, 0.0);
        break;
      case LabelPosition.bottomRight:
        left = _getX(station.x) + gap;
        top = _getY(station.y) + gap;
        translation = Offset.zero;
        break;
      case LabelPosition.rotatedUpLeft:
        left = _getX(station.x) - gap;
        top = _getY(station.y) - gap;
        translation = const Offset(-1.0, -1.0);
        break;
      case LabelPosition.rotatedUpRight:
        left = _getX(station.x) + gap;
        top = _getY(station.y) - gap;
        translation = const Offset(0.0, -1.0);
        break;
      case LabelPosition.rotatedDownLeft:
        left = _getX(station.x) - gap;
        top = _getY(station.y) + gap;
        translation = const Offset(-1.0, 0.0);
        break;
      case LabelPosition.rotatedDownRight:
        left = _getX(station.x) + gap;
        top = _getY(station.y) + gap;
        translation = Offset.zero;
        break;
    }

    return Positioned(
      left: left,
      top: top,
      child: FractionalTranslation(
        translation: translation,
        child: Transform.rotate(
          angle: rotation,
          alignment: _rotationAlignment(pos),
          child: GestureDetector(
            onTap: () => widget.onStationSelected(station),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              color: Colors.transparent,
              child: labelText,
            ),
          ),
        ),
      ),
    );
  }

  double _labelRotation(LabelPosition position) {
    return switch (position) {
      // Text extends away from the station while the near end remains anchored.
      LabelPosition.rotatedUpLeft ||
      LabelPosition.rotatedDownRight => math.pi / 4,
      LabelPosition.rotatedUpRight ||
      LabelPosition.rotatedDownLeft => -math.pi / 4,
      _ => 0.0,
    };
  }

  Alignment _rotationAlignment(LabelPosition position) {
    return switch (position) {
      LabelPosition.rotatedUpLeft ||
      LabelPosition.rotatedDownLeft => Alignment.centerRight,
      LabelPosition.rotatedUpRight ||
      LabelPosition.rotatedDownRight => Alignment.centerLeft,
      _ => Alignment.center,
    };
  }

  double _labelGap(LabelPosition position) {
    return switch (position) {
      LabelPosition.rotatedUpLeft ||
      LabelPosition.rotatedUpRight ||
      LabelPosition.rotatedDownLeft ||
      LabelPosition.rotatedDownRight => 30.0,
      _ => 16.0,
    };
  }

  List<Widget> _buildLineBadges() {
    final badges = <Widget>[];

    for (final line in MetroData.lines) {
      if (line.stationIds.isEmpty) continue;

      final first = MetroData.getStation(line.stationIds.first);
      final second = line.stationIds.length > 1
          ? MetroData.getStation(line.stationIds[1])
          : null;
      final last = MetroData.getStation(line.stationIds.last);
      final beforeLast = line.stationIds.length > 1
          ? MetroData.getStation(line.stationIds[line.stationIds.length - 2])
          : null;

      if (first != null && _shouldShowLineBadge(line.id, isStart: true)) {
        badges.add(
          _buildLineBadge(
            line: line,
            station: first,
            neighbor: second,
            isStart: true,
          ),
        );
      }

      if (last != null &&
          last.id != first?.id &&
          _shouldShowLineBadge(line.id, isStart: false)) {
        badges.add(
          _buildLineBadge(
            line: line,
            station: last,
            neighbor: beforeLast,
            isStart: false,
          ),
        );
      }
    }

    return badges;
  }

  bool _shouldShowLineBadge(String lineId, {required bool isStart}) {
    return switch ((lineId, isStart)) {
      ('line_a', true) => true,
      ('line_a', false) => true,
      ('line_b', true) => true,
      ('line_b', false) => true,
      ('line_c', true) => true,
      ('line_c', false) => true,
      _ => true,
    };
  }

  Widget _buildLineBadge({
    required MetroLine line,
    required Station station,
    required Station? neighbor,
    required bool isStart,
  }) {
    const tapSize = 52.0;
    const badgeSize = 30.0;
    final offset = _badgeOffset(station, neighbor, isStart);
    final isSelected = widget.focusedLineId == line.id;
    final textColor = line.color.computeLuminance() > 0.55
        ? Colors.black87
        : Colors.white;

    return Positioned(
      left: _getX(station.x) + offset.dx - tapSize / 2,
      top: _getY(station.y) + offset.dy - tapSize / 2,
      child: GestureDetector(
        onTap: () => widget.onLineSelected(line.id),
        child: SizedBox(
          width: tapSize,
          height: tapSize,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: isSelected ? badgeSize + 6 : badgeSize,
              height: isSelected ? badgeSize + 6 : badgeSize,
              decoration: BoxDecoration(
                color: line.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: isSelected ? 4 : 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${line.number}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Offset _badgeOffset(Station station, Station? neighbor, bool isStart) {
    if (neighbor == null) return const Offset(0, -42);

    final stationOffset = Offset(_getX(station.x), _getY(station.y));
    final neighborOffset = Offset(_getX(neighbor.x), _getY(neighbor.y));
    final direction = stationOffset - neighborOffset;
    final distance = direction.distance;
    if (distance == 0) return const Offset(0, -42);

    return direction / distance * 42.0;
  }

  Color _stationDotColor(Station station, bool isFrom, bool isTo) {
    if (isFrom) return Colors.blue;
    if (isTo) return Colors.green;
    return MetroData.getLine(station.lineId)?.color ?? Colors.grey;
  }

  LabelPosition _getLabelPosition(Station station) {
    const overrides = {
      'strasnicka': LabelPosition.left,
      'flora': LabelPosition.top,
      'zelivskeho': LabelPosition.top,
      'nemocnice_motol': LabelPosition.rotatedDownLeft,
      'petriny': LabelPosition.rotatedDownLeft,
      'nadrazi_veleslavin': LabelPosition.rotatedDownLeft,
      'borislavka': LabelPosition.rotatedDownLeft,
      'dejvicka': LabelPosition.rotatedDownLeft,
      'hradcanska': LabelPosition.left,
      'malostranska': LabelPosition.left,
      'staromestska': LabelPosition.rotatedDownLeft,
      'mustek_a': LabelPosition.left,
      'mustek_b': LabelPosition.left,
      'muzeum_a': LabelPosition.right,
      'muzeum_c': LabelPosition.right,
      'namesti_miru': LabelPosition.bottom,
      'depo_hostivar': LabelPosition.top,
      'zlicin': LabelPosition.left,
      'stodulky': LabelPosition.left,
      'luka': LabelPosition.left,
      'luziny': LabelPosition.top,
      'hurka': LabelPosition.top,
      'nove_butovice': LabelPosition.bottom,
      'jinonice': LabelPosition.right,
      'radlicka': LabelPosition.right,
      'smichovske_nadrazi': LabelPosition.left,
      'andel': LabelPosition.left,
      'karlovo_namesti': LabelPosition.bottom,
      'narodni_trida': LabelPosition.left,
      'namesti_republiky': LabelPosition.top,
      'florenc_b': LabelPosition.top,
      'florenc_c': LabelPosition.top,
      'krizikova': LabelPosition.bottom,
      'invalidovna': LabelPosition.right,
      'palmovka': LabelPosition.right,
      'ceskomoravska': LabelPosition.left,
      'vysocanska': LabelPosition.top,
      'kolbenova': LabelPosition.rotatedUpRight,
      'hloubetin': LabelPosition.rotatedUpRight,
      'rajska_zahrada': LabelPosition.rotatedUpRight,
      'cerny_most': LabelPosition.rotatedUpRight,
      'letnany': LabelPosition.top,
      'prosek': LabelPosition.bottom,
      'strizkov': LabelPosition.top,
      'ladvi': LabelPosition.top,
      'kobylisy': LabelPosition.top,
      'nadrazi_holesovice': LabelPosition.left,
      'vltavska': LabelPosition.left,
      'hlavni_nadrazi': LabelPosition.right,
      'ip_pavlova': LabelPosition.right,
      'vysehrad': LabelPosition.right,
      'prazskeho_povstani': LabelPosition.right,
      'pankrac': LabelPosition.right,
      'budejovicka': LabelPosition.left,
      'kacerov': LabelPosition.top,
      'roztyly': LabelPosition.top,
      'chodov': LabelPosition.top,
      'opatov': LabelPosition.top,
      'haje': LabelPosition.top,
    };

    if (overrides.containsKey(station.id)) {
      return overrides[station.id]!;
    }

    switch (station.lineId) {
      case 'line_a':
        return LabelPosition.bottom;
      case 'line_b':
        return LabelPosition.bottom;
      case 'line_c':
        return LabelPosition.right;
      default:
        return LabelPosition.right;
    }
  }
}

enum LabelPosition {
  left,
  right,
  top,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  rotatedUpLeft,
  rotatedUpRight,
  rotatedDownLeft,
  rotatedDownRight,
}

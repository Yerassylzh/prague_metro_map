import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/route.dart';
import '../models/station.dart';
import '../services/app_review_service.dart';
import '../services/interstitial_ad_service.dart';
import '../services/rate_prompt_service.dart';
import '../services/route_service.dart';
import '../services/translation_service.dart';
import '../widgets/ad_banner.dart';
import '../widgets/metro_map.dart';
import '../widgets/route_details_sheet.dart';
import 'feedback_screen.dart';

const _headerColor = Color(0xFF0077B6);
const _headerOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  Station? _fromStation;
  Station? _toStation;
  MetroRoute? _currentRoute;
  String? _focusedLineId;
  bool _isRatePromptVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    TranslationService().addListener(_onLanguageChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowRatePrompt());
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeShowRatePrompt();
    }
  }

  void _onStationSelected(Station station) {
    setState(() {
      _focusedLineId = null;
      if (_fromStation == null) {
        _fromStation = station;
      } else if (_toStation == null) {
        if (station.id == _fromStation!.id) {
          _fromStation = null;
        } else {
          _toStation = station;
          _calculateRoute();
        }
      } else {
        _fromStation = station;
        _toStation = null;
        _currentRoute = null;
      }
    });
  }

  void _calculateRoute() {
    if (_fromStation != null && _toStation != null) {
      _currentRoute = RouteService.findRoute(
        _fromStation!.id,
        _toStation!.id,
      );
    }
  }

  Future<void> _clearSelection() async {
    final hadRoute = _currentRoute != null;

    setState(() {
      _fromStation = null;
      _toStation = null;
      _currentRoute = null;
      _focusedLineId = null;
    });

    if (hadRoute) {
      await InterstitialAdService().recordRouteClearedAndMaybeShowAd();
    }
  }

  void _setFromStation(Station station) {
    setState(() {
      _focusedLineId = null;
      _fromStation = station;
      if (_toStation != null) {
        _calculateRoute();
      }
    });
  }

  void _setToStation(Station station) {
    setState(() {
      _focusedLineId = null;
      _toStation = station;
      if (_fromStation != null) {
        _calculateRoute();
      }
    });
  }

  void _onLineSelected(String lineId) {
    setState(() {
      _focusedLineId = _focusedLineId == lineId ? null : lineId;
      if (_focusedLineId != null) {
        _fromStation = null;
        _toStation = null;
        _currentRoute = null;
      }
    });
  }

  void _clearLineFocus() {
    setState(() => _focusedLineId = null);
  }

  Future<void> _openReview() async {
    final opened = await const AppReviewService().openStoreReview();
    if (opened) {
      await const RatePromptService().markRated();
    }

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(TranslationService().t('feedback.reviewUnavailable')),
        ),
      );
    }
  }

  void _openFeedback() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FeedbackScreen()),
    );
  }

  Future<void> _maybeShowRatePrompt() async {
    if (!mounted || _isRatePromptVisible) return;
    _isRatePromptVisible = true;
    try {
      final shouldShow = await const RatePromptService().shouldShowPrompt();
      if (!shouldShow || !mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) => const _RateUsDialog(),
      );
    } finally {
      _isRatePromptVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _headerOverlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        body: Column(
          children: [
            const TopAdBanner(),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MetroMap(
                    fromStation: _fromStation,
                    toStation: _toStation,
                    route: _currentRoute,
                    focusedLineId: _focusedLineId,
                    onStationSelected: _onStationSelected,
                    onLineSelected: _onLineSelected,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: _MapCircleButton(
                      assetPath: 'assets/animations/review_button.gif',
                      onPressed: _openReview,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _MapCircleButton(
                      icon: Icons.menu_rounded,
                      onPressed: _openFeedback,
                    ),
                  ),
                  RouteDetailsSheet(
                    fromStation: _fromStation,
                    toStation: _toStation,
                    route: _currentRoute,
                    focusedLineId: _focusedLineId,
                    onFromSelected: _setFromStation,
                    onToSelected: _setToStation,
                    onClear: _clearSelection,
                    onLineClear: _clearLineFocus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RateUsDialog extends StatelessWidget {
  const _RateUsDialog();

  Future<void> _rate(BuildContext context) async {
    final opened = await const AppReviewService().openStoreReview();
    if (opened) {
      await const RatePromptService().markRated();
    }

    if (context.mounted) {
      Navigator.of(context).pop();
      if (!opened) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(TranslationService().t('feedback.reviewUnavailable')),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService().t;

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/animations/rating5.gif',
            height: 34,
            fit: BoxFit.contain,
            gaplessPlayback: true,
          ),
          const SizedBox(height: 16),
          Text(
            t('feedback.rateDialogTitle'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _headerColor,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t('feedback.rateDialogBody'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              height: 1.25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t('common.cancel')),
        ),
        FilledButton(
          onPressed: () => _rate(context),
          style: FilledButton.styleFrom(backgroundColor: _headerColor),
          child: Text(t('feedback.rateAction')),
        ),
      ],
    );
  }
}

class _MapCircleButton extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final VoidCallback onPressed;

  const _MapCircleButton({
    this.icon,
    this.assetPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: const Color(0x66000000),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: assetPath == null
                ? Icon(
                    icon,
                    color: _headerColor,
                    size: 26,
                  )
                : ClipOval(
                    child: Image.asset(
                      assetPath!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

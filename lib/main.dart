import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/language_selection_screen.dart';
import 'services/app_config_service.dart';
import 'services/interstitial_ad_service.dart';
import 'services/translation_service.dart';
import 'services/language_preference_service.dart';
import 'screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedLanguageCode =
      await LanguagePreferenceService().getSavedLanguageCode();
  await AppConfigService().load();
  await TranslationService().loadTranslations(savedLanguageCode ?? 'en');
  await MobileAds.instance.initialize();
  InterstitialAdService().preloadInterstitialAd();
  runApp(PragueMetroApp(showLanguageSelection: savedLanguageCode == null));
}

class PragueMetroApp extends StatefulWidget {
  final bool showLanguageSelection;

  const PragueMetroApp({
    super.key,
    required this.showLanguageSelection,
  });

  @override
  State<PragueMetroApp> createState() => _PragueMetroAppState();
}

class _PragueMetroAppState extends State<PragueMetroApp> {
  late bool _showLanguageSelection;

  @override
  void initState() {
    super.initState();
    _showLanguageSelection = widget.showLanguageSelection;
    TranslationService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    TranslationService().removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onLanguageSelected() {
    setState(() => _showLanguageSelection = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService().t;

    return MaterialApp(
      title: t('app.title'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: _showLanguageSelection
          ? LanguageSelectionScreen(onLanguageSelected: _onLanguageSelected)
          : const MapScreen(),
    );
  }
}

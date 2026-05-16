import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config_service.dart';

class InterstitialAdService {
  static final InterstitialAdService _instance =
      InterstitialAdService._internal();

  factory InterstitialAdService() => _instance;

  InterstitialAdService._internal();

  static const _fallbackAndroidTestUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const _stationInfoViewCountKey = 'station_info_view_count';
  static const _clearedRouteCountKey = 'cleared_route_count';
  static const _stationInfoViewsPerAd = 3;
  static const _clearedRoutesPerAd = 5;

  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitialAd = false;
  bool _isShowingInterstitialAd = false;

  void preloadInterstitialAd() {
    if (_interstitialAd != null || _isLoadingInterstitialAd) return;

    _isLoadingInterstitialAd = true;

    final adUnitId =
        AppConfigService().admobStationInfoInterstitialAdUnitId.isEmpty
            ? _fallbackAndroidTestUnitId
            : AppConfigService().admobStationInfoInterstitialAdUnitId;

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoadingInterstitialAd = false;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _isLoadingInterstitialAd = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<void> recordStationInfoViewedAndMaybeShowAd() async {
    final prefs = await SharedPreferences.getInstance();
    final viewCount = (prefs.getInt(_stationInfoViewCountKey) ?? 0) + 1;
    await prefs.setInt(_stationInfoViewCountKey, viewCount);

    if (viewCount % _stationInfoViewsPerAd != 0) {
      preloadInterstitialAd();
      return;
    }

    await showInterstitialAdIfReady();
  }

  Future<void> recordRouteClearedAndMaybeShowAd() async {
    final prefs = await SharedPreferences.getInstance();
    final clearCount = (prefs.getInt(_clearedRouteCountKey) ?? 0) + 1;
    await prefs.setInt(_clearedRouteCountKey, clearCount);

    if (clearCount % _clearedRoutesPerAd != 0) {
      preloadInterstitialAd();
      return;
    }

    await showInterstitialAdIfReady();
  }

  Future<void> showInterstitialAdIfReady() async {
    if (_isShowingInterstitialAd) return;

    final ad = _interstitialAd;
    if (ad == null) {
      preloadInterstitialAd();
      return;
    }

    _interstitialAd = null;
    _isShowingInterstitialAd = true;

    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isShowingInterstitialAd = false;
        preloadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _isShowingInterstitialAd = false;
        preloadInterstitialAd();
      },
    );

    await ad.show();
  }
}

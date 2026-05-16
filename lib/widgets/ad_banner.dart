import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/app_config_service.dart';

enum AdBannerPlacement { top, bottom }

class AdBanner extends StatefulWidget {
  final AdBannerPlacement placement;

  const AdBanner({
    super.key,
    required this.placement,
  });

  const AdBanner.top({super.key}) : placement = AdBannerPlacement.top;

  const AdBanner.bottom({super.key}) : placement = AdBannerPlacement.bottom;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class TopAdBanner extends AdBanner {
  const TopAdBanner({super.key}) : super.top();
}

class BottomAdBanner extends AdBanner {
  const BottomAdBanner({super.key}) : super.bottom();
}

class _AdBannerState extends State<AdBanner> {
  static const _reservedHeight = 100.0;
  static const _placeholderColor = Color(0xFFF3F7FB);
  static const _fallbackAndroidTestUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  BannerAd? _bannerAd;
  AdSize? _adSize;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd == null) {
      _loadBanner();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadBanner() async {
    final width = MediaQuery.sizeOf(context).width.truncate();
    final adSize = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || adSize == null) return;

    final adUnitId = AppConfigService().admobTopBannerAdUnitId.isEmpty
        ? _fallbackAndroidTestUnitId
        : AppConfigService().admobTopBannerAdUnitId;

    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _bannerAd = ad as BannerAd;
            _adSize = adSize;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _adSize = null;
              _isLoaded = false;
            });
          }
        },
      ),
    );

    await bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    final bannerAd = _bannerAd;
    final adSize = _adSize;

    return SafeArea(
      top: widget.placement == AdBannerPlacement.top,
      bottom: widget.placement == AdBannerPlacement.bottom,
      child: Container(
        height: _reservedHeight,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: !_isLoaded || bannerAd == null || adSize == null
              ? const _AdPlaceholder()
              : SizedBox(
                  width: adSize.width.toDouble(),
                  height: adSize.height.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
        ),
      ),
    );
  }
}

class _AdPlaceholder extends StatelessWidget {
  const _AdPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _AdBannerState._placeholderColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDCE7EF)),
      ),
    );
  }
}

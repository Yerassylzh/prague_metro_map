import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfigService {
  static final AppConfigService _instance = AppConfigService._internal();

  factory AppConfigService() => _instance;

  AppConfigService._internal();

  String privacyPolicyUrl = '';
  String supportEmail = '';
  String admobTopBannerAdUnitId = '';
  String admobStationInfoInterstitialAdUnitId = '';

  Future<void> load() async {
    try {
      final jsonString = await rootBundle.loadString('assets/env.json');
      final config = json.decode(jsonString) as Map<String, dynamic>;

      privacyPolicyUrl = (config['privacy_policy_url'] as String? ?? '').trim();
      supportEmail = (config['support_email'] as String? ?? '').trim();
      admobTopBannerAdUnitId =
          (config['admob_top_banner_ad_unit_id'] as String? ?? '').trim();
      admobStationInfoInterstitialAdUnitId =
          (config['admob_station_info_interstitial_ad_unit_id'] as String? ??
                  '')
              .trim();
    } on Object {
      privacyPolicyUrl = '';
      supportEmail = '';
      admobTopBannerAdUnitId = '';
      admobStationInfoInterstitialAdUnitId = '';
    }
  }
}

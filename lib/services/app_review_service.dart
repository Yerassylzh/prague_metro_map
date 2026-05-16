import 'package:flutter/services.dart';

class AppReviewService {
  static const _channel = MethodChannel('prague_metro_map/app_review');

  const AppReviewService();

  Future<bool> openStoreReview() async {
    try {
      return await _channel.invokeMethod<bool>('openStoreReview') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<bool> openUrl(String url) async {
    try {
      return await _channel.invokeMethod<bool>('openUrl', {'url': url}) ??
          false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<bool> sendEmail({
    required String email,
    required String subject,
  }) async {
    try {
      return await _channel.invokeMethod<bool>('sendEmail', {
            'email': email,
            'subject': subject,
          }) ??
          false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}

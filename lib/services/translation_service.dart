import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class TranslationService extends ChangeNotifier {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  Map<String, dynamic> _translations = {};
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  Future<void> loadTranslations(String languageCode) async {
    _currentLanguage = languageCode;
    final jsonString = await rootBundle.loadString(
      'assets/translations/$languageCode.json',
    );
    _translations = json.decode(jsonString);
    notifyListeners();
  }

  String t(String key, {Map<String, dynamic>? params}) {
    final keys = key.split('.');
    dynamic value = _translations;

    for (final k in keys) {
      if (value is Map && value.containsKey(k)) {
        value = value[k];
      } else {
        return key;
      }
    }

    if (value is String) {
      if (params != null) {
        return _interpolate(value, params);
      }
      return value;
    }

    return key;
  }

  String _interpolate(String template, Map<String, dynamic> params) {
    String result = template;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }

  String tPlural(String key, int count, {Map<String, dynamic>? params}) {
    final pluralKey = _getPluralKey(key, count);
    final mergedParams = <String, dynamic>{'count': count};
    if (params != null) {
      mergedParams.addAll(params);
    }
    return t(pluralKey, params: mergedParams);
  }

  String _getPluralKey(String baseKey, int count) {
    final language = _currentLanguage;

    if (language == 'ru') {
      if (count % 10 == 1 && count % 100 != 11) {
        return '${baseKey}_one';
      } else if ([2, 3, 4].contains(count % 10) &&
          ![12, 13, 14].contains(count % 100)) {
        return '${baseKey}_few';
      } else {
        return '${baseKey}_many';
      }
    }

    if (count == 0) return '${baseKey}_zero';
    if (count == 1) return '${baseKey}_one';
    return '${baseKey}_other';
  }
}

extension TranslationExtension on String {
  String tr({Map<String, dynamic>? params}) {
    return TranslationService().t(this, params: params);
  }

  String trPlural(int count, {Map<String, dynamic>? params}) {
    return TranslationService().tPlural(this, count, params: params);
  }
}

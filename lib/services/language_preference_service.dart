import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferenceService {
  static const _languageCodeKey = 'language_code';

  Future<String?> getSavedLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_languageCodeKey);
    if (savedLanguageCode == 'uz') {
      await prefs.setString(_languageCodeKey, 'cs');
      return 'cs';
    }
    return savedLanguageCode;
  }

  Future<void> saveLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }
}

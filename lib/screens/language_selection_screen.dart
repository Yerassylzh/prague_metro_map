import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/language_preference_service.dart';
import '../services/translation_service.dart';

const _headerColor = Color(0xFF0077B6);
const _headerOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: _headerColor,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

class LanguageSelectionScreen extends StatelessWidget {
  final VoidCallback onLanguageSelected;

  const LanguageSelectionScreen({
    super.key,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _headerOverlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F7FB),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: _headerColor,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prague Metro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Choose app language',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _LanguageOption(
                      code: 'cs',
                      title: 'Cestina',
                      subtitle: 'Czech',
                      onSelected: onLanguageSelected,
                    ),
                    _LanguageOption(
                      code: 'ru',
                      title: 'Русский',
                      subtitle: 'Russian',
                      onSelected: onLanguageSelected,
                    ),
                    _LanguageOption(
                      code: 'en',
                      title: 'English',
                      subtitle: 'English',
                      onSelected: onLanguageSelected,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String code;
  final String title;
  final String subtitle;
  final VoidCallback onSelected;

  const _LanguageOption({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await LanguagePreferenceService().saveLanguageCode(code);
            await TranslationService().loadTranslations(code);
            onSelected();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6F3FA),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      code.toUpperCase(),
                      style: const TextStyle(
                        color: _headerColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

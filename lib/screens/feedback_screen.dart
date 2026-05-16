import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/app_config_service.dart';
import '../services/app_review_service.dart';
import '../services/language_preference_service.dart';
import '../services/rate_prompt_service.dart';
import '../services/translation_service.dart';
import '../widgets/ad_banner.dart';

const _headerColor = Color(0xFF0077B6);
const _dividerColor = Color(0xFFD0D0D0);
const _headerOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  static const _languages = [
    _LanguageChoice(code: 'en', title: 'English', subtitle: 'English'),
    _LanguageChoice(code: 'ru', title: 'Russian', subtitle: 'RU'),
    _LanguageChoice(code: 'cs', title: 'Cestina', subtitle: 'CS'),
  ];

  Future<void> _writeToUs(BuildContext context) async {
    final t = TranslationService().t;
    final email = AppConfigService().supportEmail;
    final opened = email.isNotEmpty &&
        await const AppReviewService().sendEmail(
          email: email,
          subject: t('feedback.emailSubject'),
        );

    if (!opened && context.mounted) {
      _showUnavailable(context, t('feedback.emailUnavailable'));
    }
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final t = TranslationService().t;
    final url = AppConfigService().privacyPolicyUrl;
    final opened =
        url.isNotEmpty && await const AppReviewService().openUrl(url);

    if (!opened && context.mounted) {
      _showUnavailable(context, t('feedback.privacyUnavailable'));
    }
  }

  Future<void> _rateApp(BuildContext context) async {
    final opened = await const AppReviewService().openStoreReview();
    if (opened) {
      await const RatePromptService().markRated();
    }

    if (!opened && context.mounted) {
      _showUnavailable(
        context,
        TranslationService().t('feedback.reviewUnavailable'),
      );
    }
  }

  void _showUnavailable(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _changeLanguage(String languageCode) async {
    await LanguagePreferenceService().saveLanguageCode(languageCode);
    await TranslationService().loadTranslations(languageCode);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService().t;
    final currentLanguage = TranslationService().currentLanguage;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _headerOverlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        bottomNavigationBar: const BottomAdBanner(),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SafeArea(
                bottom: false,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _FeedbackBlock(
                child: Column(
                  children: [
                    Text(
                      t('feedback.contactPrompt'),
                      textAlign: TextAlign.center,
                      style: _FeedbackTextStyles.body,
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => _writeToUs(context),
                      child: Text(
                        t('feedback.writeUs'),
                        style: _FeedbackTextStyles.link,
                      ),
                    ),
                  ],
                ),
              ),
              _FeedbackBlock(
                child: Text(
                  t('feedback.sharePrompt'),
                  textAlign: TextAlign.center,
                  style: _FeedbackTextStyles.link,
                ),
              ),
              _FeedbackBlock(
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => _rateApp(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        Text(
                          t('feedback.ratePrompt'),
                          textAlign: TextAlign.center,
                          style: _FeedbackTextStyles.link,
                        ),
                        const SizedBox(height: 14),
                        Image.asset(
                          'assets/animations/rating5.gif',
                          height: 27,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _FeedbackBlock(
                child: TextButton(
                  onPressed: () => _openPrivacyPolicy(context),
                  child: Text(
                    t('feedback.privacyPolicy'),
                    textAlign: TextAlign.center,
                    style: _FeedbackTextStyles.link,
                  ),
                ),
              ),
              _FeedbackBlock(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      t('settings.language'),
                      textAlign: TextAlign.center,
                      style: _FeedbackTextStyles.body,
                    ),
                    const SizedBox(height: 14),
                    for (final language in _languages)
                      _LanguageOption(
                        language: language,
                        selected: currentLanguage == language.code,
                        onTap: () => _changeLanguage(language.code),
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

class _FeedbackBlock extends StatelessWidget {
  final Widget child;

  const _FeedbackBlock({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _dividerColor, width: 6)),
      ),
      child: child,
    );
  }
}

class _LanguageChoice {
  final String code;
  final String title;
  final String subtitle;

  const _LanguageChoice({
    required this.code,
    required this.title,
    required this.subtitle,
  });
}

class _LanguageOption extends StatelessWidget {
  final _LanguageChoice language;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? const Color(0xFFE6F3FA) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: selected ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? _headerColor : _dividerColor,
                width: selected ? 1.4 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: selected ? _headerColor : const Color(0xFFE6F3FA),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      language.code.toUpperCase(),
                      style: TextStyle(
                        color: selected ? Colors.white : _headerColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.title,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        language.subtitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    color: _headerColor,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackTextStyles {
  static const body = TextStyle(
    color: Color(0xFF444444),
    fontSize: 19,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const link = TextStyle(
    color: _headerColor,
    fontSize: 18,
    height: 1.2,
    fontWeight: FontWeight.w800,
  );
}

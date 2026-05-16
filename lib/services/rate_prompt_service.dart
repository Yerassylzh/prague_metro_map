import 'package:shared_preferences/shared_preferences.dart';

class RatePromptService {
  static const _launchCountKey = 'rate_prompt_launch_count';
  static const _completedKey = 'rate_prompt_completed_v2';
  static const _lastShownLaunchKey = 'rate_prompt_last_shown_launch_v2';
  static const _promptEveryLaunches = 7;

  const RatePromptService();

  Future<bool> shouldShowPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_completedKey) ?? false) return false;

    final launchCount = (prefs.getInt(_launchCountKey) ?? 0) + 1;
    await prefs.setInt(_launchCountKey, launchCount);

    final lastShownLaunch = prefs.getInt(_lastShownLaunchKey) ?? 0;
    final launchesSincePrompt = launchCount - lastShownLaunch;

    if (launchCount < _promptEveryLaunches ||
        launchesSincePrompt < _promptEveryLaunches) {
      return false;
    }

    await prefs.setInt(_lastShownLaunchKey, launchCount);
    return true;
  }

  Future<void> markRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completedKey, true);
  }
}

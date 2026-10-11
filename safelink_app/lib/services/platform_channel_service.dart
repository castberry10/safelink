import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PlatformChannelService {
  static const _platform = MethodChannel("io.github.castberry10.safelink/channel");
  static const platform = MethodChannel('predict_channel');

  /// Set this app as the default browser
  Future<void> setAsDefaultBrowser() async {
    try {
      debugPrint('Calling setAsDefaultBrowser()');
      await _platform.invokeMethod("setAsDefaultBrowser");
    } on PlatformException catch (e) {
      debugPrint('Failed to set default browser: $e');
      rethrow;
    }
  }

  /// Retrieve the list of installed browsers
  Future<List<dynamic>> getInstalledBrowsers() async {
    try {
      debugPrint('Calling getInstalledBrowsers()');
      final List<Object?> browsers =
          await _platform.invokeMethod("getInstalledBrowsers");
      debugPrint('Installed browsers: $browsers');
      return browsers;
    } on PlatformException catch (e) {
      debugPrint('Failed to get browser list: $e');
      rethrow;
    }
  }

  Future<void> openOtherBrowser(String url, String defaultBrowser) async {
    try {
      await _platform.invokeMethod(
          'openOtherBrowser', {'url': url, 'defaultBrowser': defaultBrowser});
    } on PlatformException catch (e) {
      debugPrint('Failed to open browser: $e');
      rethrow;
    }
  }

  Future<void> showPhishingAlarm(String username, String websiteUrl) async {
    try {
      final result = await _platform.invokeMethod('showPhishingAlarm', {
        'username': username,
        'websiteUrl': websiteUrl,
      });
      debugPrint('showPhishingAlarm result: $result');
    } catch (e) {
      debugPrint('showPhishingAlarm error: $e');
    }
  }
}
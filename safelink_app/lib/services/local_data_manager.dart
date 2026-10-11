import 'package:safelink_app/const/value_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataManager {
  static late SharedPreferences prefs;
  static const int _currentDataVersion = 3;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    final storedVersion = prefs.getInt(ValueName.version) ?? 0;

    // Apply any pending migrations before validation
    if (storedVersion > 0 && storedVersion < _currentDataVersion) {
      await _migrate(from: storedVersion);
    }

    // Validate all stored values — reset if any field is missing or malformed
    if (!_isDataValid()) {
      await initData();
    }
  }

  // Transforms known old-format values to the current format.
  static Future<void> _migrate({required int from}) async {
    if (from <= 2) {
      // language: stored as display name → language code
      final lang = prefs.getString(ValueName.language);
      if (lang == 'English') {
        await prefs.setString(ValueName.language, 'en');
      } else if (lang == '한국어') {
        await prefs.setString(ValueName.language, 'kr');
      }

      // languageList: display names → language codes
      await prefs.setStringList(ValueName.languageList, ['kr', 'en']);

      // useBrowser: Korean "not selected" sentinel → English sentinel
      final browser = prefs.getString(ValueName.useBrowser);
      if (browser == '미선택' || browser == null) {
        await prefs.setString(ValueName.useBrowser, 'none');
      }

      // useBrowserPackageName was not initialized in v1/v2 initData
      final pkg = prefs.getString(ValueName.useBrowserPackageName);
      if (pkg == null) {
        await prefs.setString(ValueName.useBrowserPackageName, 'none');
      }
    }

    await prefs.setInt(ValueName.version, _currentDataVersion);
  }

  // Returns true only when every stored field has the expected type and value.
  static bool _isDataValid() {
    // String fields — must be non-null
    if (prefs.getString(ValueName.username) == null) return false;

    // language — must be 'en'
    final lang = prefs.getString(ValueName.language);
    if (lang == null || lang != 'en') return false;

    // languageList — must exist
    final langList = prefs.getStringList(ValueName.languageList);
    if (langList == null || langList.isEmpty) return false;

    // useBrowser — must be non-null and not the old Korean sentinel
    final browser = prefs.getString(ValueName.useBrowser);
    if (browser == null || browser == '미선택') return false;

    // useBrowserPackageName — must be non-null
    if (prefs.getString(ValueName.useBrowserPackageName) == null) return false;

    // Bool fields — must all be non-null (SharedPreferences returns null for wrong type)
    for (final key in [
      ValueName.login,
      ValueName.dark,
      ValueName.defaultBrowser,
      ValueName.logging,
      ValueName.autoOpen,
    ]) {
      if (prefs.getBool(key) == null) return false;
    }

    // List fields — must be non-null (empty list is valid)
    if (prefs.getStringList(ValueName.history) == null) return false;

    // Version — must be non-null
    if (prefs.getInt(ValueName.version) == null) return false;

    return true;
  }

  static Future<void> initData() async {
    await prefs.clear();
    await prefs.setString(ValueName.username, 'Gest');
    await prefs.setBool(ValueName.login, false);
    await prefs.setBool(ValueName.dark, false);
    await prefs.setString(ValueName.language, 'en');
    await prefs.setStringList(ValueName.languageList, ['en']);
    await prefs.setString(ValueName.useBrowser, 'none');
    await prefs.setString(ValueName.useBrowserPackageName, 'none');
    await prefs.setBool(ValueName.defaultBrowser, false);
    await prefs.setBool(ValueName.autoOpen, true);
    await prefs.setBool(ValueName.logging, true);
    await prefs.setStringList(ValueName.history, []);
    await prefs.setInt(ValueName.version, _currentDataVersion);
  }

  Future<void> addVisitedUrl(String url) async {
    final history = prefs.getStringList(ValueName.history) ?? [];
    history.remove(url);
    history.insert(0, url);
    if (history.length > 20) history.removeLast();
    await prefs.setStringList(ValueName.history, history);
  }

  Future<void> deleteVisitedUrl() async {
    await prefs.setStringList(ValueName.history, []);
  }

  Future<bool?> getBoolData(String key) async => prefs.getBool(key);
  Future<String?> getStringData(String key) async => prefs.getString(key);
  Future<List<String>?> getStringListData(String key) async => prefs.getStringList(key);
  Future<void> setBoolData(String key, bool value) async => prefs.setBool(key, value);
  Future<void> setStringData(String key, String value) async => prefs.setString(key, value);
}
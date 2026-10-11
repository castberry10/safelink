import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService extends ChangeNotifier {
  static final LocalizationService instance = LocalizationService._();
  LocalizationService._();

  // Maps language code to its display label shown in UI
  static const Map<String, String> codeToDisplayName = {
    'en': 'English',
    'kr': '한국어',
  };

  // Ordered list of all supported language codes
  static const List<String> availableLanguageCodes = ['kr', 'en'];

  Map<String, dynamic> _strings = {};
  String _languageCode = 'en';

  String get languageCode => _languageCode;

  Future<void> load(String languageCode) async {
    try {
      final raw = await rootBundle.loadString('assets/i18n/$languageCode.json');
      _strings = json.decode(raw) as Map<String, dynamic>;
      _languageCode = languageCode;
    } catch (_) {
      final raw = await rootBundle.loadString('assets/i18n/en.json');
      _strings = json.decode(raw) as Map<String, dynamic>;
      _languageCode = 'en';
    }
    notifyListeners();
  }

  String get(String key) => _strings[key] as String? ?? key;
}

/// Access translated strings from anywhere with tr(key)
String tr(String key) => LocalizationService.instance.get(key);
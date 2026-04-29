import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_keys.dart';

class SettingsProvider extends ChangeNotifier {
  String _language = 'en';
  bool _notificationsEnabled = true;

  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString(AppKeys.selectedLang) ?? 'en';
    _notificationsEnabled = prefs.getBool(AppKeys.notificationsEnabled) ?? true;
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _language = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppKeys.selectedLang, code);
    notifyListeners();
  }

  Future<void> setNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppKeys.notificationsEnabled, enabled);
    notifyListeners();
  }
}

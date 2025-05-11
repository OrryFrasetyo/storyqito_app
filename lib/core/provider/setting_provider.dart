import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:storyqito_app/core/constant/my_pref_key.dart';
import 'package:storyqito_app/core/data/model/setting.dart';
import 'package:storyqito_app/core/data/repository/setting_repository.dart';

class SettingProvider extends ChangeNotifier {
  final SettingRepository _settingRepository;

  String _message = "";
  String get message => _message;

  Setting? _setting;
  Setting? get setting => _setting;

  Locale _locale = const Locale("en");
  Locale get locale => _locale;

  SettingProvider(this._settingRepository) {
    _initializeSettings();
  }

  void _initializeSettings() {
    try {
      final isDarkSystem =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

      final bool savedIsDark =
          _settingRepository.isDarkModeSet()
              ? _settingRepository.getSettingValue().isDark
              : isDarkSystem;

      final String savedLanguage =
          _settingRepository.getString(SettingPrefsKey.languageKey) ?? "en";
      _locale = Locale(savedLanguage);

      _setting = Setting(isDark: savedIsDark, locale: savedLanguage);

      _message = "Settings initialized successfully";
    } catch (e) {
      _message = "Failed to initialize settings";
    }
    notifyListeners();
  }

  Future<void> saveSettingValue(Setting value) async {
    try {
      await _settingRepository.saveSettingValue(value);
      _setting = value;
      _locale = Locale(value.locale);
      _message = "Your data is saved";
    } catch (e) {
      _message = "Failed to save your data";
    }
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    try {
      await _settingRepository.setTheme(isDark);
      if (_setting != null) {
        _setting = _setting!.copyWith(isDark: isDark);
      } else {
        _setting = Setting(isDark: isDark, locale: _locale.languageCode);
      }
      _message = "Theme successfully updated.";
    } catch (e) {
      _message = "Failed to update theme. Please try again.";
    }
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    try {
      await _settingRepository.setLocale(languageCode);
      _locale = Locale(languageCode);
      if (_setting != null) {
        _setting = _setting!.copyWith(locale: languageCode);
      } else {
        _setting = Setting(
          isDark:
              WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark,
          locale: languageCode,
        );
      }
      _message = "Language successfully updated";
    } catch (e) {
      _message = "Failed to update language. Please try again.";
    }
    notifyListeners();
  }
}

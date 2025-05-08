import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyqito_app/core/data/model/setting.dart';

class SettingRepository {
  final SharedPreferences _sharedPreferences;

  SettingRepository(this._sharedPreferences);

  static const String themeKey = "STORYQITO_THEME";
  static const String languageKey = "STORYQITO_LANGUAGE";

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _sharedPreferences.setBool(themeKey, setting.isDark);
      await _sharedPreferences.setString(languageKey, setting.locale);
    } catch (e) {
      throw Exception("Shared preferences can't save the setting value.");
    }
  }

  Future<void> setTheme(bool isDark) async {
    try {
      await _sharedPreferences.setBool(themeKey, isDark);
    } catch (e) {
      throw Exception("Failed setting theme.");
    }
  }

  Setting getSettingValue() {
    return Setting(
      isDark: _sharedPreferences.getBool(themeKey) ?? true,
      locale: _sharedPreferences.getString(languageKey) ?? "en",
    );
  }

  bool isDarkModeSet() {
    return _sharedPreferences.containsKey(themeKey);
  }

  Future<void> setLocale(String languageCode) async {
    try {
      await _sharedPreferences.setString(languageKey, languageCode);
    } catch (e) {
      throw Exception("Failed setting locale.");
    }
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }
}
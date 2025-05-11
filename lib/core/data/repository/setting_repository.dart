import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyqito_app/core/constant/my_pref_key.dart';
import 'package:storyqito_app/core/data/model/setting.dart';

class SettingRepository {
  final SharedPreferences _sharedPreferences;

  SettingRepository(this._sharedPreferences);

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _sharedPreferences.setBool(
        SettingPrefsKey.themeKey,
        setting.isDark,
      );
      await _sharedPreferences.setString(
        SettingPrefsKey.languageKey,
        setting.locale,
      );
    } catch (e) {
      throw Exception("Shared preferences can't save the setting value.");
    }
  }

  Future<void> setTheme(bool isDark) async {
    try {
      await _sharedPreferences.setBool(SettingPrefsKey.themeKey, isDark);
    } catch (e) {
      throw Exception("Failed setting theme.");
    }
  }

  Setting getSettingValue() {
    return Setting(
      isDark: _sharedPreferences.getBool(SettingPrefsKey.themeKey) ?? true,
      locale: _sharedPreferences.getString(SettingPrefsKey.languageKey) ?? "en",
    );
  }

  bool isDarkModeSet() {
    return _sharedPreferences.containsKey(SettingPrefsKey.themeKey);
  }

  Future<void> setLocale(String languageCode) async {
    try {
      await _sharedPreferences.setString(
        SettingPrefsKey.languageKey,
        languageCode,
      );
    } catch (e) {
      throw Exception("Failed setting locale.");
    }
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }
}

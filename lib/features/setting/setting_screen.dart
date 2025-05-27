import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/setting/setting_provider.dart';
import 'package:storyqito_app/features/widget/language_picker.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final settingProvider = context.watch<SettingProvider>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.setting,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SwitchListTile(
                  value: settingProvider.setting?.isDark ?? false,
                  onChanged: (bool value) {
                    settingProvider.setTheme(value);
                  },
                  title: Text(
                    localizations.dark_theme,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  secondary: const Icon(Icons.dark_mode_rounded),
                ),
                const SizedBox(width: 24.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.language,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      leading: const Icon(Icons.language),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      trailing: SizedBox(
                        width: 140,
                        child: LanguagePicker(
                          onLanguageChanged:
                              (code) => settingProvider.setLocale(code),
                          selectedLanguageCode:
                              settingProvider.locale.languageCode,
                          isCompactMode: false,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

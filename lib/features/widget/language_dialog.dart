import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/setting/setting_provider.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final settingProvider = context.watch<SettingProvider>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AppProvider>().closeLanguageDialog();
          });
        }
      },
      child: AlertDialog(
        title: Text(localizations.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageTile(
              context: context,
              code: "en",
              flag: Image.asset(
                "assets/flag/flag_us.webp",
                width: 28,
                height: 24,
              ),
              name: localizations.english,
              currentCode: settingProvider.locale.languageCode,
            ),
            _buildLanguageTile(
              context: context,
              code: "id",
              flag: Image.asset(
                "assets/flag/flag_id.webp",
                width: 28,
                height: 24,
              ),
              name: localizations.indonesian,
              currentCode: settingProvider.locale.languageCode,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<AppProvider>().closeLanguageDialog(),
            child: Text(localizations.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required String code,
    required Image flag,
    required String name,
    required String currentCode,
  }) {
    final settingProvider = context.watch<SettingProvider>();
    final isSelected = currentCode == code;

    return ListTile(
      title: Text(name),
      leading: flag,
      trailing: isSelected ? Icon(Icons.check) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      onTap: () {
        settingProvider.setLocale(code);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<AppProvider>().closeLanguageDialog();
        });
      },
    );
  }
}

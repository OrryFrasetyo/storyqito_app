import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/setting/setting_provider.dart';

class LanguagePicker extends StatelessWidget {
  final String selectedLanguageCode;
  final bool isCompactMode;

  const LanguagePicker({
    super.key,
    required this.selectedLanguageCode,
    this.isCompactMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return isCompactMode
        ? _buildCompactSelector(context, localizations)
        : _buildDropdownSelector(context, localizations);
  }

  Widget _buildDropdownSelector(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final settingProvider = context.read<SettingProvider>();

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        items: [
          DropdownMenuItem<String>(
            value: "en",
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/flag/flag_us.webp",
                  width: 28.0,
                  height: 24.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  localizations.english,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: "id",
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/flag/flag_id.webp",
                  width: 28.0,
                  height: 24.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  localizations.indonesian,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
        value: selectedLanguageCode,
        onChanged: (value) {
          if (value != null) {
            settingProvider.setLocale(value);
          }
        },
        buttonStyleData: ButtonStyleData(
          width: double.infinity,
          height: 40.0,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.arrow_drop_down, size: 18.0),
          iconEnabledColor: Theme.of(context).colorScheme.onPrimaryContainer,
          iconDisabledColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(36.0),
            thickness: WidgetStateProperty.all(6.0),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
      ),
    );
  }

  Widget _buildCompactSelector(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: localizations.language,
      onPressed: () {
        context.read<AppProvider>().openLanguageDialog();
      },
    );
  }
}

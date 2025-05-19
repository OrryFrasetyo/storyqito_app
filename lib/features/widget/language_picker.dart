import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';

class LanguagePicker extends StatelessWidget {
  final Function(String) onLanguageChanged;
  final String selectedLanguageCode;
  final bool isCompactMode;

  const LanguagePicker({
    super.key,
    required this.onLanguageChanged,
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
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: false,
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
                Flexible(
                  child: Text(
                    localizations.english,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
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
                Flexible(
                  child: Text(
                    localizations.indonesian,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
        value: selectedLanguageCode,
        onChanged: (value) {
          if (value != null) {
            onLanguageChanged(value);
          }
        },
        buttonStyleData: ButtonStyleData(
          width: 140,
          height: 40.0,
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.arrow_drop_down),
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
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
        ),
      ),
    );
  }

  Widget _buildCompactSelector(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return IconButton(
      icon: const Icon(Icons.language_rounded),
      tooltip: localizations.language,
      onPressed: () {
        context.read<AppProvider>().openLanguageDialog();
      },
    );
  }
}

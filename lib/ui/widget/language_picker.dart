import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

class LanguagePicker extends StatelessWidget {
  final Function(String) onLanguageChanged;
  final String selectedLanguageCode;
  final VoidCallback? onTapDialog;
  final bool isCompactMode;

  const LanguagePicker({
    super.key,
    required this.onLanguageChanged,
    required this.selectedLanguageCode,
    this.onTapDialog,
    this.isCompactMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return isCompactMode
        ? IconButton(
          icon: Icon(Icons.language),
          tooltip: localizations.language,
          onPressed: onTapDialog, 
          )
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
            onLanguageChanged(value);
          }
        },
        buttonStyleData: ButtonStyleData(
          height: 40.0,
          // width: 140,
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
}

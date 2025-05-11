import 'package:flutter/material.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

class LanguageDialog extends StatelessWidget {
  final Function(String) onLanguageChanged;
  final String selectedLanguageCode;
  final VoidCallback onCancel;

  const LanguageDialog({
    super.key,
    required this.onLanguageChanged,
    required this.selectedLanguageCode,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageTile(
            context,
            'en',
            Image.asset("assets/flag/flag_us.webp", width: 28, height: 24),
            localizations.english,
            localizations,
          ),
          _buildLanguageTile(
            context,
            'id',
            Image.asset("assets/flag/flag_id.webp", width: 28, height: 24),
            localizations.indonesian,
            localizations,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: onCancel, child: Text(localizations.cancel)),
      ],
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String code,
    Image flag,
    String name,
    AppLocalizations localizations,
  ) {
    final isSelected = selectedLanguageCode == code;

    return ListTile(
      title: Text(name),
      leading: flag,
      trailing: isSelected ? Icon(Icons.check) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      onTap: () {
        onLanguageChanged(code);
      },
    );
  }
}

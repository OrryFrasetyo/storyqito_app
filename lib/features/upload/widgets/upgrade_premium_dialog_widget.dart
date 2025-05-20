import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';

class UpgradePremiumDialogWidget extends StatelessWidget {
  const UpgradePremiumDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.read<AppProvider>();
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.get_premium),
      content: Text(localizations.premium_benefits_description),
      actions: [
        TextButton(
          onPressed: () => appProvider.closeUpgradeDialog(),
          child: Text(localizations.close),
        ),
        FilledButton(
          onPressed: () {
            appProvider.closeUpgradeDialog();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(localizations.coming_soon)));
          },
          child: Text(localizations.upgrade),
        ),
      ],
    );
  }
}

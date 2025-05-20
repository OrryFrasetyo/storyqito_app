import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';

class BuildPremiumFeature extends StatelessWidget {
  const BuildPremiumFeature({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 36.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 12),
            Text(
              localizations.premium_feature,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              localizations.upgrade_to_add_location,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            OutlinedButton.icon(
              onPressed: () {
                context.read<AppProvider>().openUpgradeDialog();
              },
              label: Text(AppLocalizations.of(context)!.upgrade_now),
            ),
          ],
        ),
      ),
    );
  }
}

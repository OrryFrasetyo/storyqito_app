import 'package:flutter/material.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

class NoUserWidget extends StatelessWidget {
  const NoUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(child: Text(localizations.no_user_data));
  }
}

import 'package:flutter/material.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.story_not_found),
            ElevatedButton(
              onPressed: () => context.navigateToHome(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(AppLocalizations.of(context)!.go_to_home),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

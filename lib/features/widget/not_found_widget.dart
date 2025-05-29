import 'package:flutter/material.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/routes/app_router.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localizations.story_not_found),
            ElevatedButton(
              onPressed: () => context.navigateToHome(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(localizations.go_to_home),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

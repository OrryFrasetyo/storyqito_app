import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

class StoryErrorWidget extends StatelessWidget {
  final String errorMsg;
  final VoidCallback onRetry;

  const StoryErrorWidget({
    super.key,
    required this.errorMsg,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/animation/error.json",
            fit: BoxFit.contain,
            width: 64.0,
            height: 64.0,
          ),
          const SizedBox(height: 16.0),
          Text(
            "${localizations.error_loading_stories} $errorMsg",
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: onRetry,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(localizations.retry),
            ),
          ),
        ],
      ),
    );
  }
}

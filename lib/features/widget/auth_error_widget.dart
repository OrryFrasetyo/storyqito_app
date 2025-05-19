import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

class AuthErrorWidget extends StatelessWidget {
  final String errorMsg;
  final VoidCallback onLogout;

  const AuthErrorWidget({
    super.key,
    required this.errorMsg,
    required this.onLogout,
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
            "${localizations.error} $errorMsg",
            style: const TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: onLogout,
            child: Text(localizations.logout),
          ),
        ],
      ),
    );
  }
}

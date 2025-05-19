import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/auth/auth_provider.dart';

class LogoutDialogWidget extends StatelessWidget {
  const LogoutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();
    final appProvider = context.read<AppProvider>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            appProvider.closeDialogLogOut();
          });
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          localizations.logout_confirm,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        content: Text(
          localizations.logout_confirm_message,
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              appProvider.closeDialogLogOut();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                appProvider.closeDialogLogOut();
                if (authProvider.isLogoutSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.logout_success)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(authProvider.errorMsg)),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLowest,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(localizations.logout),
            ),
          ),
        ],
      ),
    );
  }
}

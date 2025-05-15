import 'package:flutter/material.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

String getLocalizedErrorMsg(BuildContext context, String error) {
  if (error.contains("Location services are disabled")) {
    return AppLocalizations.of(context)!.location_services_disabled;
  } else if (error.contains("Location permissions are denied")) {
    return AppLocalizations.of(context)!.location_permissions_denied;
  } else if (error.contains("permanently denied")) {
    return AppLocalizations.of(
      context,
    )!.location_permissions_permanently_denied;
  }
  return AppLocalizations.of(context)!.location_error;
}
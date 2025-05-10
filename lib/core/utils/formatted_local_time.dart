import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

String formatLocalTime(DateTime createdAt) {
  return DateFormat("MMMM d, yyyy · HH:mm").format(createdAt.toLocal());
}

String getTimeDifference(BuildContext context, DateTime createdAt) {
    final localizations = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('MMM d, yyyy · HH:mm');
    final formattedDate = dateFormat.format(createdAt);
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    String timeAgo;

    if (difference.inDays > 7) {
      timeAgo = formattedDate;
    } else if (difference.inDays > 0) {
      timeAgo =
          '${difference.inDays} ${difference.inDays == 1 ? localizations.d_ago_singular : localizations.d_ago_plural}';
    } else if (difference.inHours > 0) {
      timeAgo =
          '${difference.inHours} ${difference.inHours == 1 ? localizations.h_ago_singular : localizations.h_ago_plural}';
    } else if (difference.inMinutes > 0) {
      timeAgo =
          '${difference.inMinutes} ${difference.inMinutes == 1 ? localizations.m_ago_singular : localizations.m_ago_plural}';
    } else {
      timeAgo = localizations.just_now;
    }
    return timeAgo;
  }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/response/stories_response.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/routes/my_route_delegate.dart';

class StoryCardWidget extends StatelessWidget {
  final ListStory story;

  const StoryCardWidget({super.key, required this.story});

  String _getTimeDifference(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('MMM d, yyyy · HH:mm');
    final formattedDate = dateFormat.format(story.createdAt);
    final now = DateTime.now();
    final difference = now.difference(story.createdAt);
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          context.read<MyRouteDelegate>().navigateToStoryDetail(story);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          story.name.isNotEmpty
                              ? story.name[0].toUpperCase()
                              : localizations.question_mark,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.name,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _getTimeDifference(context),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Hero(
              tag: "story-image-${story.id}",
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12.0),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minWidth: double.infinity,
                        maxHeight: 400.0,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                          maxHeight: 300.0,
                        ),
                        child: Image.network(
                          story.photoUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

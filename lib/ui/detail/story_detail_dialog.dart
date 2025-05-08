import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/network/response/stories_response.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/utils/formatted_local_time.dart';

class StoryDetailDialog extends StatelessWidget {
  final ListStory story;
  final VoidCallback onBack;

  const StoryDetailDialog({
    super.key,
    required this.story,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 800 ? 700.0 : screenWidth * 0.8;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: (screenWidth - dialogWidth) / 2,
        vertical: 24,
      ),
      child: Container(
        width: dialogWidth,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // header with close button
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 8,
                top: 8,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.story_detail,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: onBack, // use callback
                  ),
                ],
              ),
            ),

            Divider(height: 1),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: double.infinity,
                        minHeight: 400,
                      ),
                      child: Image.network(
                        story.photoUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 350,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 350,
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

                    // content
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
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      story.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      formatLocalTime(story.createdAt),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            story.description,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

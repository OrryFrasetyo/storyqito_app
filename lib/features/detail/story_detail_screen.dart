import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/network/response/list_story.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/utils/formatted_local_time.dart';
import 'package:storyqito_app/features/detail/widget/story_location_map_widget.dart';

class StoryDetailScreen extends StatelessWidget {
  final ListStory story;
  final VoidCallback onBackPressed;

  const StoryDetailScreen({
    super.key,
    required this.story,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.story_detail,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: onBackPressed,
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: "story-image-${story.id}",
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: double.infinity,
                    minHeight: 200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      story.photoUrl,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingStatus) {
                        if (loadingStatus == null) return child;
                        return Container(
                          constraints: const BoxConstraints(minHeight: 350),
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingStatus.expectedTotalBytes != null
                                      ? loadingStatus.cumulativeBytesLoaded /
                                          loadingStatus.expectedTotalBytes!
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
                                size: 64.0,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStoryAuthorInfo(context),
                  const SizedBox(height: 16.0),
                  Text(
                    story.description,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 24.0),

                  if (story.lat != null && story.lon != null)
                    _buildLocationDetails(context, localizations),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryAuthorInfo(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            story.name.isNotEmpty
                ? story.name[0].toUpperCase()
                : AppLocalizations.of(context)!.question_mark,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatLocalTime(story.createdAt),
                style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDetails(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16.0),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 8.0),
            Text(
              localizations.location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Text(
          "${localizations.latitude}: ${story.lat?.toStringAsFixed(6)}, ${localizations.longitude}: ${story.lon?.toStringAsFixed(6)}",
          style: const TextStyle(fontSize: 14.0),
        ),
        const SizedBox(height: 16),
        StoryLocationMapWidget(
          key: ValueKey('detail-location-map-${story.id}'),
          latitude: story.lat!,
          longitude: story.lon!,
          height: 400.0,
        ),
      ],
    );
  }
}

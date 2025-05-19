import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/utils/formatted_local_time.dart';
import 'package:storyqito_app/features/detail/widget/detail_image_widget.dart';
import 'package:storyqito_app/features/detail/widget/location_widget.dart';

class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final story = context.read<AppProvider>().selectedStory!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.story_detail,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AppProvider>().closeDetail();
            });
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "story-image-${story.id}",
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: 200,
                ),
                child: DetailImageWidget(photoUrl: story.photoUrl),
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
                    LocationWidget(
                      mapControlsEnabled: true,
                      mapKeyPrefix: "detail",
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryAuthorInfo(BuildContext context) {
    final story = context.read<AppProvider>().selectedStory!;

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
}

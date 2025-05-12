import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/network/responses/list_story.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/utils/formatted_local_time.dart';
import 'package:storyqito_app/features/detail/widget/location_widget.dart';

class StoryDetailDialog extends StatelessWidget {
  final ListStory story;
  final VoidCallback onClose;

  const StoryDetailDialog({
    super.key,
    required this.story,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 800 ? 700.0 : screenWidth * 0.8;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          onClose();
        }
      },
      child: Dialog(
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
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, localizations),
              Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStoryImage(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStoryAuthorInfo(context),
                            const SizedBox(height: 16.0),
                            Text(
                              story.description,
                              style: TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(height: 24.0),

                            if (story.lat != null && story.lon != null)
                              LocationWidget(
                                listStory: story,
                                mapControlsEnabled: false,
                                mapKeyPrefix: "dialog",
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 8.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localizations.story_detail,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
        ],
      ),
    );
  }

  Widget _buildStoryImage() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 400.0,
      ),
      child: Image.network(
        story.photoUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 350.0,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            ),
          );
        },
        errorBuilder:
            (context, error, stackTrace) => Container(
              height: 350.0,
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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                formatLocalTime(story.createdAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

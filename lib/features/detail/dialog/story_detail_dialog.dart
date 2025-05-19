import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/utils/formatted_local_time.dart';
import 'package:storyqito_app/core/utils/open_url.dart';
import 'package:storyqito_app/features/detail/widget/detail_image_widget.dart';
import 'package:storyqito_app/features/detail/widget/location_widget.dart';

class StoryDetailDialog extends StatefulWidget {
  const StoryDetailDialog({super.key});

  @override
  State<StoryDetailDialog> createState() => _StoryDetailDialogState();
}

class _StoryDetailDialogState extends State<StoryDetailDialog> {
  final ScrollController _scrollController = ScrollController();
  Timer? _someTimer;
  bool _showScrollbar = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _someTimer = Timer(Duration(milliseconds: 800), () {
        if (mounted && _scrollController.offset == 0.0) {
          setState(() => _showScrollbar = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _someTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = context.read<AppProvider>().selectedStory!;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 800 ? 700.0 : screenWidth * 0.8;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<AppProvider>().closeDetail();
        });
      },
      child: Stack(
        children: [
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
              horizontal: (screenWidth - dialogWidth) / 2,
              vertical: 24,
            ),
            child: PointerInterceptor(
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
                    Flexible(
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: _showScrollbar,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStoryImage(story.photoUrl),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.close_rounded, size: 28, color: Colors.white),
              onPressed: () {
                context.read<AppProvider>().closeDetail();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryImage(String photoUrl) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 400.0,
      ),
      child: GestureDetector(
        onTap: () => openUrl(photoUrl),
        child: DetailImageWidget(photoUrl: photoUrl),
      )
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

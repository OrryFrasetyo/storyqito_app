import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/response/list_story.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/map_provider.dart';
import 'package:storyqito_app/core/provider/story_provider.dart';
import 'package:storyqito_app/core/routes/my_route_delegate.dart';
import 'package:storyqito_app/features/map/ui/widgets/empty_story_map_widget.dart';
import 'package:storyqito_app/features/map/ui/widgets/story_map_card_widget.dart';

class StoryMapListWidget extends StatelessWidget {
  final Function(ListStory)? onStoryTap;

  const StoryMapListWidget({super.key, this.onStoryTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final storyProvider = context.watch<StoryProvider>();
    final mapProvider = context.watch<MapProvider>();

    // error state view
    if (storyProvider.errorMsg.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, size: 64.0, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              "${localizations.error_loading_stories} ${storyProvider.errorMsg}",
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => mapProvider.refreshStories(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(localizations.retry),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        mapProvider.refreshStories();
      },
      child: CustomScrollView(
        controller: mapProvider.scrollController,
        slivers: [
          if (storyProvider.isLoading && storyProvider.stories.isEmpty)
            SliverToBoxAdapter(
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          if (storyProvider.stories.isEmpty && !storyProvider.isLoading)
            SliverToBoxAdapter(
              child: EmptyStoryMapWidget(localizations: localizations),
            ),

          if (storyProvider.stories.isNotEmpty) _buildSliverStoryList(context),

          // show loading indicator at the bottom when loading more
          if (storyProvider.isLoading && storyProvider.stories.isNotEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSliverStoryList(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == storyProvider.stories.length &&
                storyProvider.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (index >= storyProvider.stories.length) {
              return null;
            }

            final story = storyProvider.stories[index];

            return GestureDetector(
              onTap: () {
                if (onStoryTap != null) {
                  onStoryTap!(story);
                } else {
                  context.read<MapProvider>().onStoryTap(story);
                }
              },
              onDoubleTap:
                  () => context.read<MyRouteDelegate>().navigateToStoryDetail(
                    story,
                  ),
              child: Card(
                margin: EdgeInsets.only(bottom: 16),
                child: StoryMapCardWidget(
                  listStory: story,
                  isLocationVisible: story.lat != null && story.lon != null,
                ),
              ),
            );
          },
          childCount:
              storyProvider.stories.length + (storyProvider.isLoading ? 1 : 0),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/responses/list_story.dart';
import 'package:storyqito_app/core/provider/auth/auth_provider.dart';
import 'package:storyqito_app/core/provider/map/map_provider.dart';
import 'package:storyqito_app/core/provider/story/story_provider.dart';
import 'package:storyqito_app/core/routes/my_route_delegate.dart';
import 'package:storyqito_app/features/home/widgets/empty_story_widget.dart';
import 'package:storyqito_app/features/home/widgets/story_error_widget.dart';
import 'package:storyqito_app/features/map/ui/widgets/story_map_card_widget.dart';

class StoryMapListWidget extends StatelessWidget {
  final Function(ListStory)? onStoryTap;

  const StoryMapListWidget({super.key, this.onStoryTap});

  void _refreshStories(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<StoryProvider>().refreshStories(user: authProvider.user!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();
    final mapProvider = context.watch<MapProvider>();

    if (storyProvider.state.isError) {
      return Center(
        child: StoryErrorWidget(
          errorMsg: storyProvider.state.errorMessage!,
          onRetry: () => _refreshStories(context),
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
          if (storyProvider.state.isLoading && storyProvider.stories.isEmpty ||
              storyProvider.state.isInitial)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (storyProvider.state.isError)
            SliverFillRemaining(
              child: StoryErrorWidget(
                errorMsg: storyProvider.state.errorMessage!,
                onRetry: () => _refreshStories(context),
              ),
            )
          else if (storyProvider.stories.isEmpty)
            EmptyStoryWidget()
          else if (storyProvider.state.isLoaded)
            _buildSliverStoryList(context),

          if (storyProvider.state.isLoading && storyProvider.stories.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
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
              storyProvider.stories.length +
              (storyProvider.state.isLoading ? 1 : 0),
        ),
      ),
    );
  }
}

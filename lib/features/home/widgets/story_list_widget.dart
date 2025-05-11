import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/auth_provider.dart';
import 'package:storyqito_app/core/provider/story_provider.dart';
import 'package:storyqito_app/features/home/widgets/story_card_widget.dart';

class StoryListWidget extends StatelessWidget {
  final ScrollController scrollController;
  final StoryProvider storyProvider;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;

  const StoryListWidget({
    super.key,
    required this.scrollController,
    required this.storyProvider,
    required this.onRefresh,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return RefreshIndicator(
      onRefresh: () async {
        if (authProvider.user != null) {
          await storyProvider.refreshStories(user: authProvider.user!);
        }
      },
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          _buildAppBar(context),

          if (storyProvider.isLoading && storyProvider.stories.isEmpty)
             const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          if (storyProvider.stories.isEmpty && !storyProvider.isLoading)
            _buildNoStories(context),

          if (storyProvider.stories.isNotEmpty) _buildSliverStoryList(),

          if (storyProvider.isLoading && storyProvider.stories.isNotEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SliverAppBar(
      primary: true,
      snap: true,
      floating: true,
      forceElevated: false,
      title: Row(
        children: [
          Text(
            localizations.name_app,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onRefresh,
          icon: Icon(Icons.refresh, color: Colors.purple),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () => onLogout,
            icon: Icon(Icons.logout, color: Colors.red),
          ),
        ),
      ],
      elevation: 0,
    );
  }

  Widget _buildNoStories(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_stories, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              localizations.no_stories,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                localizations.pull_to_refresh,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverStoryList() {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == storyProvider.stories.length &&
                storyProvider.isLoading) {
              return Center(
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
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 460),
                child: StoryCardWidget(story: story),
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

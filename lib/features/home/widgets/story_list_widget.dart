import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/static/story_load_state.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/auth/auth_provider.dart';
import 'package:storyqito_app/core/provider/story/story_provider.dart';
import 'package:storyqito_app/features/widget/empty_story_widget.dart';
import 'package:storyqito_app/features/home/widgets/story_card_widget.dart';
import 'package:storyqito_app/features/widget/story_error_widget.dart';

class StoryListWidget extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback onLogout;

  const StoryListWidget({
    super.key,
    required this.scrollController,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final storyProvider = context.read<StoryProvider>();

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

          if (storyProvider.state.isLoading && storyProvider.stories.isEmpty ||
              storyProvider.state.isInitial)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (storyProvider.state.isError)
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StoryErrorWidget(
                  errorMsg: storyProvider.state.errorMessage!,
                  onRetry: () => _refreshStories(context),
                ),
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

  void _refreshStories(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<StoryProvider>().refreshStories(user: authProvider.user!);
    }
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
        if (context.watch<AppProvider>().selectedStory == null) ...[
          IconButton(
            onPressed: () {
              _refreshStories(context);
            },
            icon: const Icon(Icons.refresh, color: Colors.purple),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: onLogout,
              icon: Icon(Icons.logout, color: Colors.red),
            ),
          ),
        ],
      ],
      elevation: 0,
    );
  }

  Widget _buildSliverStoryList(BuildContext context) {
    final storyProvider = context.read<StoryProvider>();

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= storyProvider.stories.length) {
              return null;
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: StoryCardWidget(story: storyProvider.stories[index]),
              ),
            );
          },
          childCount:
              storyProvider.stories.length +
              (storyProvider.state is StoryLoadStateLoading ? 1 : 0),
        ),
      ),
    );
  }
}

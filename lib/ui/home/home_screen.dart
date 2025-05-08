import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/auth_provider.dart';
import 'package:storyqito_app/core/provider/story_provider.dart';
import 'package:storyqito_app/ui/home/widget/story_card_widget.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserAndStories();
    });

    _scrollController.addListener(_scrollListener);
  }

  void _loadUserAndStories() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.getUser();

    if (authProvider.user != null && mounted) {
      context.read<StoryProvider>().getStories(user: authProvider.user!);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      final authProvider = context.read<AuthProvider>();
      final storyProvider = context.read<StoryProvider>();

      if (storyProvider.hasMoreStories &&
          !storyProvider.isLoading &&
          authProvider.user != null) {
        storyProvider.getStories(user: authProvider.user!);
      }
    }
  }

  void _refreshStories() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<StoryProvider>().refreshStories(user: authProvider.user!);
    }
  }

  void _logOut(AuthProvider authProvider) async {
    await authProvider.logout();
    widget.onLogout();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.logout_success)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Consumer2<AuthProvider, StoryProvider>(
        builder: (context, authProvider, storyProvider, child) {
          if (authProvider.isLoadingLogin) {
            return Center(child: CircularProgressIndicator());
          }

          if (authProvider.errorMsg.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animation/error.json",
                    fit: BoxFit.contain,
                    width: 64.0,
                    height: 64.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "${localizations.error} ${authProvider.errorMsg}",
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: widget.onLogout,
                    child: Text(localizations.logout),
                  ),
                ],
              ),
            );
          }

          if (authProvider.user == null) {
            return Center(child: Text(localizations.no_user_data));
          }

          if (storyProvider.errorMsg.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animation/error.json",
                    fit: BoxFit.contain,
                    width: 64.0,
                    height: 64.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "${localizations.error_loading_stories} ${storyProvider.errorMsg}",
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (authProvider.user != null) {
                        storyProvider.refreshStories(user: authProvider.user!);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(localizations.retry),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (authProvider.user != null) {
                await storyProvider.refreshStories(user: authProvider.user!);
              }
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
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
                      onPressed: _refreshStories,
                      icon: Icon(Icons.refresh, color: Colors.purple),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () => _logOut(authProvider),
                        icon: Icon(Icons.logout, color: Colors.red),
                      ),
                    ),
                  ],
                  elevation: 0,
                ),

                if (storyProvider.isLoading && storyProvider.stories.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),

                if (storyProvider.stories.isEmpty && !storyProvider.isLoading)
                  _buildNoStories(),

                if (storyProvider.stories.isNotEmpty)
                  _buildSliverStoryList(storyProvider),

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
        },
      ),
    );
  }

  Widget _buildNoStories() {
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

  Widget _buildSliverStoryList(StoryProvider storyProvider) {
    return SliverPadding(
      padding: EdgeInsets.all(16.0),
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

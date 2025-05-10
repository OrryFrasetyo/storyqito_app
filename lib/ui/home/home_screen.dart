import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/auth_provider.dart';
import 'package:storyqito_app/core/provider/story_provider.dart';
import 'package:storyqito_app/ui/home/widgets/auth_error_widget.dart';
import 'package:storyqito_app/ui/home/widgets/loading_widget.dart';
import 'package:storyqito_app/ui/home/widgets/no_user_widget.dart';
import 'package:storyqito_app/ui/home/widgets/story_error_widget.dart';
import 'package:storyqito_app/ui/home/widgets/story_list_widget.dart';

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
      _loadStories();
    }
  }

  void _loadStories() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<StoryProvider>().getStories(user: authProvider.user!);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  bool _isShouldLoadMore() {
    return _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500;
  }

  void _scrollListener() {
    if (_isShouldLoadMore()) {
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

  void _showLogoutSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.logout_success)),
    );
  }

  void _logOut(AuthProvider authProvider) async {
    await authProvider.logout();
    widget.onLogout();
    if (mounted) {
      _showLogoutSuccessMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Consumer2<AuthProvider, StoryProvider>(
        builder: (context, authProvider, storyProvider, child) {
          if (authProvider.isLoadingLogin) {
            return LoadingViewWidget();
          }

          if (authProvider.errorMsg.isNotEmpty) {
            return AuthErrorWidget(
              errorMsg: authProvider.errorMsg,
              onLogout: widget.onLogout,
            );
          }

          if (authProvider.user == null) {
            return NoUserWidget();
          }

          if (storyProvider.errorMsg.isNotEmpty) {
            return StoryErrorWidget(
              errorMsg: storyProvider.errorMsg,
              onRetry: () => _refreshStories(),
            );
          }

          return StoryListWidget(
            scrollController: _scrollController,
            storyProvider: storyProvider,
            onRefresh: _refreshStories,
            onLogout: () => _logOut(authProvider),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storyqito_app/core/data/network/responses/list_story.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/auth/auth_provider.dart';
import 'package:storyqito_app/features/auth/animation/auth_screen_animation.dart';
import 'package:storyqito_app/features/auth/screen/login_screen.dart';
import 'package:storyqito_app/features/auth/screen/register_screen.dart';
import 'package:storyqito_app/features/detail/dialog/story_detail_dialog.dart';
import 'package:storyqito_app/features/detail/screen/story_detail_screen.dart';
import 'package:storyqito_app/features/home/screen/home_screen.dart';
import 'package:storyqito_app/features/main/screen/main_screen.dart';
import 'package:storyqito_app/features/map/ui/screen/story_map_screen.dart';
import 'package:storyqito_app/features/setting/setting_screen.dart';
import 'package:storyqito_app/features/unknown/unknown_screen.dart';
import 'package:storyqito_app/features/upload/screen/upload_story_screen.dart';

class AppRouter {
  static ListStory? _currentStory;
  final AuthProvider authProvider;
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter({required this.authProvider}) {
    _initAuthState();
  }

  Future<void> _initAuthState() async {
    await authProvider.isLogged();
  }

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: "/",
    debugLogDiagnostics: false,
    refreshListenable: authProvider,
    redirect: _handleRedirect,
    errorBuilder: (context, state) => const UnknownScreen(),
    routerNeglect: false,
    routes: [
      GoRoute(
        path: "/unknown",
        name: "unknown",
        builder: (context, state) => const UnknownScreen(),
      ),

      GoRoute(
        path: "/login",
        name: "login",
        pageBuilder:
            (context, state) => AuthScreenAnimation(
              child: LoginScreen(),
              isForward: false,
              key: state.pageKey,
            ),
      ),
      GoRoute(
        path: "/register",
        name: "register",
        pageBuilder:
            (context, state) => AuthScreenAnimation(
              child: RegisterScreen(),
              isForward: true,
              key: state.pageKey,
            ),
      ),
      GoRoute(
        path: "/story/:id",
        name: "storyDetail",
        parentNavigatorKey: rootNavigatorKey,
        redirect: (context, state) async {
          if (state.extra is ListStory) {
            _currentStory = state.extra as ListStory;
          }
          if (state.extra == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(
                      context,
                    )!.direct_story_access_not_support,
                  ),
                ),
              );
            });
            return "/";
          }
          return null;
        },
        pageBuilder: (context, state) {
          return _buildStoryDetailPage(state, _currentStory);
        },
      ),

      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(
            selectedIndex: _calculateSelectedIndex(state),
            onTabSelected: (index) {
              switch (index) {
                case 0:
                  router.go("/");
                  break;
                case 1:
                  router.go("/upload");
                  break;
                case 2:
                  router.go("/map");
                  break;
                case 3:
                  router.go("/setting");
                  break;
              }
            },
            onLogout: () async {
              await authProvider.logout();
              router.go("/login");
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: "/",
            name: "home",
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: "/upload",
            name: "upload",
            builder: (context, state) => UploadStoryScreen(),
          ),
          GoRoute(
            path: "/map",
            name: "map",
            builder: (context, state) => StoryMapScreen(),
          ),
          GoRoute(
            path: "/setting",
            name: "setting",
            builder: (context, state) => SettingScreen(),
          ),
        ],
      ),
    ],
  );

  Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final bool isLoggedIn = await authProvider.isLogged();
    var path = Uri.parse(state.matchedLocation).path;
    path = path.replaceAll(RegExp(r"/+"), "/");

    if (path.length > 1 && path.endsWith("/")) {
      path = path.substring(0, path.length - 1);
    }

    final validPaths = [
      "/",
      "/login",
      "/register",
      "/upload",
      "/map",
      "/setting",
      "/unknown",
    ];

    final isValidPath =
        validPaths.contains(path) ||
        path.startsWith("/story/") ||
        path.startsWith("/map/story/");

    if (!isValidPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.go("/unknown");
      });
      return "/unknown";
    }

    final bool isGoingToAuth = path == "/login" || path == "/register";

    if (!isLoggedIn && !isGoingToAuth && path != "/unknown") {
      return "/unknown";
    }

    if (isLoggedIn && isGoingToAuth) {
      return "/";
    }

    return null;
  }

  int _calculateSelectedIndex(GoRouterState state) {
    final String location = state.matchedLocation;

    if (location.startsWith("/upload")) {
      return 1;
    }
    if (location.startsWith("/map")) {
      return 2;
    }
    if (location.startsWith("/setting")) {
      return 3;
    }
    return 0;
  }
}

Page _buildStoryDetailPage(GoRouterState state, ListStory? persistedStory) {
  final story = persistedStory;

  if (story == null) {
    debugPrint("Warning: Invalid or missing story data. Redirecting to home.");
    return MaterialPage(
      key: state.pageKey,
      child: Builder(
        builder:
            (context) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Story not found"),
                    ElevatedButton(
                      onPressed: () => GoRouter.of(context).go("/"),
                      child: Text("Go Home"),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  return CustomTransitionPage(
    key: state.pageKey,
    fullscreenDialog: true,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: Builder(
      builder: (context) {
        final isDesktop =
            MediaQuery.of(context).size.width >= MainScreen.tabletWidthThreshold;
        return isDesktop
            ? StoryDetailDialog(
              story: story,
              onClose: () => GoRouter.of(context).pop(),
            )
            : StoryDetailScreen(
              story: story,
              onBackPressed: () => GoRouter.of(context).pop(),
            );
      },
    ),
  );
}

extension GoRouterExtension on BuildContext {
  void navigateToStoryDetail(ListStory story) {
    GoRouter.of(
      this,
    ).pushNamed("storyDetail", pathParameters: {"id": story.id}, extra: story);
  }

  void navigateToHome({int tabIndex = 0}) {
    switch (tabIndex) {
      case 0:
        GoRouter.of(this).go("/");
        break;
      case 1:
        GoRouter.of(this).go("/upload");
        break;
      case 2:
        GoRouter.of(this).go("/map");
        break;
      case 3:
        GoRouter.of(this).go('/setting');
        break;
      default:
        GoRouter.of(this).go('/');
    }
  }
}

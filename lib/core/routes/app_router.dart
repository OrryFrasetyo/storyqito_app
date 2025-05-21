import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storyqito_app/core/data/network/responses/list_story.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/auth/auth_provider.dart';
import 'package:storyqito_app/core/utils/constants.dart';
import 'package:storyqito_app/core/utils/nav_util.dart';
import 'package:storyqito_app/features/auth/animation/auth_screen_animation.dart';
import 'package:storyqito_app/features/auth/screen/login_screen.dart';
import 'package:storyqito_app/features/auth/screen/register_screen.dart';
import 'package:storyqito_app/features/detail/dialog/story_detail_dialog.dart';
import 'package:storyqito_app/features/detail/screen/story_detail_screen.dart';
import 'package:storyqito_app/features/home/screen/home_screen.dart';
import 'package:storyqito_app/features/home/widgets/logout_dialog_widget.dart';
import 'package:storyqito_app/features/main/screen/main_screen.dart';
import 'package:storyqito_app/features/map/ui/screen/story_map_screen.dart';
import 'package:storyqito_app/features/setting/setting_screen.dart';
import 'package:storyqito_app/features/not_found/not_found_screen.dart';
import 'package:storyqito_app/features/upload/screen/upload_story_screen.dart';
import 'package:storyqito_app/features/upload/widgets/maps_fullscreen_widget.dart';
import 'package:storyqito_app/features/upload/widgets/upgrade_premium_dialog_widget.dart';
import 'package:storyqito_app/features/widget/language_dialog.dart';
import 'package:storyqito_app/features/widget/not_found_widget.dart';

class AppRouter {
  final AuthProvider authProvider;
  final AppProvider appProvider;

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter({required this.appProvider, required this.authProvider}) {
    _initAuthState();
  }

  Future<void> _initAuthState() async {
    await authProvider.isLogged();
  }

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    refreshListenable: Listenable.merge([authProvider, appProvider]),
    redirect: _handleRedirect,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routerNeglect: false,
    routes: [
      GoRoute(
        path: '/not-found',
        name: 'notFound',
        builder: (context, state) => const NotFoundScreen(),
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        redirect: (context, state) {
          if (appProvider.isRegister) {
            return '/register';
          }
          if (appProvider.isLanguageDialogOpen) {
            return '/login/language-dialog';
          }
          return null;
        },
        routes: [_languageDialogRoute('login')],

        pageBuilder: (context, state) {
          return AuthScreenAnimation(
            child: LoginScreen(),
            isForward: false,
            key: state.pageKey,
          );
        },
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        redirect: (context, state) {
          if (appProvider.isLogin) {
            return '/login';
          }
          if (appProvider.isLanguageDialogOpen) {
            return '/register/language-dialog';
          }
          return null;
        },
        routes: [_languageDialogRoute('register')],
        pageBuilder: (context, state) {
          return AuthScreenAnimation(
            child: RegisterScreen(),
            isForward: true,
            key: state.pageKey,
          );
        },
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(
            selectedIndex: calculateSelectedIndex(state.matchedLocation),
            onTabSelected: (index) {
              switch (index) {
                case 0:
                  router.go('/');
                  break;
                case 1:
                  router.go('/upload');
                  break;
                case 2:
                  router.go('/map');
                  break;
                case 3:
                  router.go('/setting');
                  break;
              }
            },
            onLogout: () async {
              await authProvider.logout();
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => HomeScreen(),
            redirect: (context, state) {
              if (appProvider.selectedStory != null) {
                return '/story/${appProvider.selectedStory!.id}';
              }
              if (appProvider.isDialogLogOutOpen) {
                return '/logout-confirmation';
              }
              if (!appProvider.isDialogLogOutOpen) {
                return '/';
              }

              return null;
            },
            routes: [
              _detailRoute(''),
              GoRoute(
                path: 'logout-confirmation',
                name: 'dialogLogOut',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  return dialogTransition(state, LogoutDialogWidget());
                },
              ),
            ],
          ),

          GoRoute(
            path: '/map',
            name: 'map',
            builder: (context, state) => StoryMapScreen(),
            redirect: (context, state) {
              if (appProvider.selectedStory != null) {
                return '/map/story/${appProvider.selectedStory!.id}';
              }
              return null;
            },
            routes: [_detailRoute('map')],
          ),

          GoRoute(
            path: '/upload',
            name: 'upload',
            builder: (context, state) => UploadStoryScreen(),
            redirect: (context, state) {
              if (appProvider.isUpDialogOpen) {
                return '/upload/upgrade';
              }

              if (appProvider.isUploadFullScreenMap) {
                return '/upload/map';
              }

              if (!appProvider.isUpDialogOpen &&
                  !appProvider.isUploadFullScreenMap) {
                return '/upload';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'upgrade',
                name: 'upgradePremiumDialog',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  return dialogTransition(state, UpgradePremiumDialogWidget());
                },
              ),

              GoRoute(
                path: 'map',
                name: 'uploadMap',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  return dialogTransition(state, MapsFullscreenWidget());
                },
              ),
            ],
          ),
          GoRoute(
            path: '/setting',
            name: 'setting',
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
    var path = Uri.parse(state.matchedLocation).path;
    path = path.replaceAll(RegExp(r'/+'), '/');

    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    final bool isLoggedIn = await authProvider.isLogged();

    final validPaths = [
      '/',
      '/not-found',
      '/login',
      '/login/language-dialog',
      '/register',
      '/register/language-dialog',
      '/logout-confirmation',
      '/story',
      '/upload',
      '/upload/map',
      '/upload/upgrade',
      '/map',
      '/setting',
    ];

    final isValidPath =
        validPaths.contains(path) ||
        path.startsWith('/story/') ||
        path.startsWith('/map/story/');

    if (!isValidPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.go('/not-found');
      });
      return '/not-found';
    }

    final bool isGoingToAuth = path == '/login' || path == '/register';

    if (!isLoggedIn &&
        !isGoingToAuth &&
        path != '/not-found' &&
        !appProvider.isLanguageDialogOpen) {
      return '/not-found';
    }

    if (isLoggedIn && isGoingToAuth) {
      return '/';
    }

    return null;
  }

  GoRoute _languageDialogRoute(String name) {
    return GoRoute(
      path: '/language-dialog',
      name: "${name}LanguageDialog",
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return dialogTransition(state, LanguageDialog());
      },
    );
  }

  GoRoute _detailRoute(String name) {
    return GoRoute(
      path: 'story/:id',
      name: "${name}StoryDetail",
      parentNavigatorKey: _rootNavigatorKey,
      redirect: (context, state) {
        debugPrint("isFullScreenMap: ${appProvider.isDetailFullScreenMap}");
        debugPrint(
          "selectedStory != null: ${appProvider.selectedStory != null}",
        );
        debugPrint("ID from path: ${state.pathParameters['id']}");

        if (appProvider.selectedStory == null && appProvider.isFromDetail) {
          return '/$name';
        }

        if (appProvider.selectedStory == null && !appProvider.isFromDetail) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.direct_story_access_not_support,
                ),
              ),
            );
          });
          return '/$name';
        }
        return null;
      },
      pageBuilder: (context, state) {
        return _buildStoryDetailPage(
          appProvider,
          state,
          appProvider.selectedStory,
        );
      },
    );
  }
}

Page _buildStoryDetailPage(
  AppProvider appProvider,
  GoRouterState state,
  ListStory? persistedStory,
) {
  if (persistedStory == null) {
    debugPrint("Warning: Invalid or missing story data. Redirect to home.");
    return MaterialPage(key: state.pageKey, child: NotFoundWidget());
  }

  return dialogTransition(
    state,
    Builder(
      builder: (context) {
        final isDesktop =
            MediaQuery.of(context).size.width >= tabletWidthThreshold;
        return isDesktop ? StoryDetailDialog() : StoryDetailScreen();
      },
    ),
  );
}

extension GoRouterExtension on BuildContext {
  void navigateToHome({int tabIndex = 0}) {
    final String path = switch (tabIndex) {
      0 => '/',
      1 => '/upload',
      2 => '/map',
      3 => '/setting',
      _ => '/',
    };
    GoRouter.of(this).go(path);
  }
}

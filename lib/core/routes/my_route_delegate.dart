// import 'package:flutter/material.dart';
// import 'package:storyqito_app/core/data/network/responses/list_story.dart';
// import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
// import 'package:storyqito_app/core/provider/auth/auth_provider.dart';
// import 'package:storyqito_app/core/provider/setting/setting_provider.dart';
// import 'package:storyqito_app/core/routes/app_route_path.dart';
// import 'package:storyqito_app/core/utils/custom_page_transition.dart';
// import 'package:storyqito_app/features/auth/animation/auth_screen_animation.dart';
// import 'package:storyqito_app/features/auth/screen/login_screen.dart';
// import 'package:storyqito_app/features/auth/screen/register_screen.dart';
// import 'package:storyqito_app/features/detail/dialog/story_detail_dialog.dart';
// import 'package:storyqito_app/features/detail/screen/story_detail_screen.dart';
// import 'package:storyqito_app/features/main/screen/main_screen.dart';
// import 'package:storyqito_app/features/widget/dialog_page.dart';
// import 'package:storyqito_app/features/widget/language_dialog.dart';

// class MyRouteDelegate extends RouterDelegate<AppRoutePath>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
//   final GlobalKey<NavigatorState> _navigationKey;
//   final AuthProvider authProvider;
//   final SettingProvider settingProvider;
//   final _mainScreenKey = GlobalKey();

//   bool _isLoginScreen = true;
//   bool _isRegisterScreen = false;
//   bool _isMainScreen = false;
//   bool _isLoggedIn = false;
//   bool _isStoryDetail = false;
//   bool _isStoryDetailDialog = false;
//   bool _isLanguageDialogOpen = false;
//   bool _isNavigateForward = true;
//   String? _currentStoryId;
//   int _currentTabIndex = 0;
//   ListStory? _currentStory;


//   MyRouteDelegate(this.authProvider, this.settingProvider)
//     : _navigationKey = GlobalKey<NavigatorState>() {
//     _init();
//   }

//   _init() async {
//     _isLoggedIn = await authProvider.isLogged();
//     if (_isLoggedIn) {
//       _isMainScreen = true;
//       _isLoginScreen = false;
//       _isRegisterScreen = false;
//     }
//     notifyListeners();
//   }

//   int get currentTabIndex => _currentTabIndex;

//   set currentTabIndex(int index) {
//     _currentTabIndex = index;
//     notifyListeners();
//   }

//   void navigateToHome({int tabIndex = 0}) {
//     _currentTabIndex = tabIndex;
//     _isMainScreen = true;
//     _isLoginScreen = false;
//     _isRegisterScreen = false;
//     _isStoryDetail = false;
//     _isStoryDetailDialog = false;
//     _currentStory = null;
//     _currentStoryId = null;
//     notifyListeners();
//   }

//   void navigateToStoryDetail(ListStory story) {
//     _currentStory = story;
//     _currentStoryId = story.id;

//     if (MediaQuery.of(navigatorKey!.currentContext!).size.width > 600) {
//       _isStoryDetailDialog = true;
//       _isStoryDetail = false;
//     } else {
//       _isStoryDetail = true;
//       _isStoryDetailDialog = false;
//     }

//     notifyListeners();
//   }

//   void showLanguageDialog() {
//     _isLanguageDialogOpen = true;
//     notifyListeners();
//   }

//   void closeLanguageDialog() {
//     _isLanguageDialogOpen = false;
//     notifyListeners();
//   }

//   @override
//   GlobalKey<NavigatorState>? get navigatorKey => _navigationKey;

//   @override
//   Future<void> setNewRoutePath(AppRoutePath path) async {
//     if (path.isUnknown) {
//       _isLoginScreen = true;
//       _isRegisterScreen = false;
//       _isMainScreen = false;
//       _isStoryDetail = false;
//       _isStoryDetailDialog = false;
//       _isLoggedIn = false;
//       _currentStory = null;
//       _currentStoryId = null;
//       return;
//     }

//     if (path.storyId != null) {
//       if (_isLoggedIn) {
//         _isLoginScreen = false;
//         _isRegisterScreen = false;
//         _isMainScreen = true;
//         _isStoryDetail = false;
//         _currentStoryId = path.storyId!;

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           final context = navigatorKey?.currentContext;
//           if (context != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   AppLocalizations.of(context)!.direct_story_access_not_support,
//                 ),
//                 duration: Duration(seconds: 3),
//               ),
//             );
//           }
//         });
//       } else {
//         _isLoginScreen = true;
//         _isRegisterScreen = false;
//         _isMainScreen = false;
//         _isStoryDetail = false;
//         _isStoryDetailDialog = false;
//       }
//       return;
//     }

//     if (path.isLoginScreen) {
//       _isLoginScreen = true;
//       _isRegisterScreen = false;
//       _isMainScreen = false;
//       _isStoryDetail = false;
//       _isStoryDetailDialog = false;
//       _isLoggedIn = false;
//       _currentStory = null;
//       _currentStoryId = null;
//     } else if (path.isRegisterScreen) {
//       _isLoginScreen = false;
//       _isRegisterScreen = true;
//       _isMainScreen = false;
//       _isStoryDetail = false;
//       _isStoryDetailDialog = false;
//       _isLoggedIn = false;
//       _currentStory = null;
//       _currentStoryId = null;
//     } else if (path.isMainScreen) {
//       if (_isLoggedIn) {
//         _isLoginScreen = false;
//         _isRegisterScreen = false;
//         _isMainScreen = true;
//         _isStoryDetail = false;
//         _isStoryDetailDialog = false;
//         _currentStory = null;
//         _currentStoryId = null;

//         if (path.tabIndex != null) {
//           _currentTabIndex = path.tabIndex!;
//         }
//       } else {
//         _isLoginScreen = true;
//         _isRegisterScreen = false;
//         _isMainScreen = false;
//         _isStoryDetail = false;
//         _isStoryDetailDialog = false;
//       }
//     }
//   }

//   @override
//   AppRoutePath get currentConfiguration {
//     if ((_isStoryDetail || _isStoryDetailDialog) && _currentStoryId != null) {
//       return AppRoutePath.detailScreen(_currentStoryId!);
//     }

//     if (_isLoggedIn) {
//       return AppRoutePath.home(tabIndex: _currentTabIndex);
//     } else if (_isLoginScreen) {
//       return AppRoutePath.login();
//     } else if (_isRegisterScreen) {
//       return AppRoutePath.register();
//     } else {
//       return AppRoutePath.unknown();
//     }
//   }

//   @override
//   Future<bool> popRoute() async {
//     if (_isStoryDetail || _isStoryDetailDialog) {
//       _isStoryDetail = false;
//       _isStoryDetailDialog = false;
//       _isMainScreen = true;
//       _currentStory = null;
//       _currentStoryId = null;
//       notifyListeners();
//       return true;
//     }

//     if (_isLoggedIn && _isMainScreen) {
//       if (_currentTabIndex != 0) {
//         _currentTabIndex = 0;
//         notifyListeners();
//         return true;
//       }
//       return false;
//     }

//     if (_isRegisterScreen) {
//       _isRegisterScreen = false;
//       _isLoginScreen = true;
//       notifyListeners();
//       return true;
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool latestLoginStatus = authProvider.isLoggedIn;
//     final isDesktop = MediaQuery.of(context).size.width > 600;

//     if (latestLoginStatus != _isLoggedIn) {
//       _isLoggedIn = latestLoginStatus;
//       if (_isLoggedIn) {
//         _isMainScreen = true;
//         _isLoginScreen = false;
//         _isRegisterScreen = false;
//         _isStoryDetail = false;
//         _isStoryDetailDialog = false;
//       } else {
//         _isMainScreen = false;
//         _isLoginScreen = true;
//         _isRegisterScreen = false;
//         _isStoryDetail = false;
//         _isStoryDetailDialog = false;
//       }
//     }

//     if (_currentStory != null) {
//       if (isDesktop) {
//         _isStoryDetailDialog = true;
//         _isStoryDetail = false;
//       } else {
//         _isStoryDetail = true;
//         _isStoryDetailDialog = false;
//       }
//     } else {
//       _isStoryDetail = false;
//       _isStoryDetailDialog = false;
//     }

//     return Navigator(
//       key: navigatorKey,
//       pages: [
//         if (_isLoginScreen)
//           AuthScreenAnimation(
//             key: const ValueKey("LoginScreen"),
//             isForward: !_isNavigateForward,
//             child: LoginScreen(
//               onLogin: () {
//                 _isLoggedIn = true;
//                 _isMainScreen = true;
//                 // _isLoginScreen = false;
//                 notifyListeners();
//               },
//               onRegister: () {
//                 _isNavigateForward = true;
//                 _isRegisterScreen = true;
//                 _isLoginScreen = false;
//                 notifyListeners();
//               },
//             ),
//           ),

//         if (_isRegisterScreen)
//           AuthScreenAnimation(
//             key: const ValueKey("RegisterScreen"),
//             isForward: _isNavigateForward,
//             child: RegisterScreen(
//               onRegister: () {
//                 _isLoggedIn = true;
//                 _isMainScreen = true;
//                 _isRegisterScreen = false;
//                 notifyListeners();
//               },
//               onLogin: () {
//                 _isNavigateForward = false;
//                 _isLoginScreen = true;
//                 _isRegisterScreen = false;
//                 notifyListeners();
//               },
//             ),
//           ),

//         if (_isMainScreen || _isStoryDetail || _isStoryDetailDialog)
//           MaterialPage(
//             key: ValueKey("MainScreen"),
//             child: MainScreen(
//               key: _mainScreenKey,
//               selectedIndex: _currentTabIndex,
//               onTabSelected: (index) {
//                 _currentTabIndex = index;
//                 notifyListeners();
//               },
//               onLogout: () {
//                 _isLoggedIn = false;
//                 _isMainScreen = false;
//                 _isLoginScreen = true;
//                 currentTabIndex = 0;
//                 _currentStory = null;
//                 _currentStoryId = null;
//                 notifyListeners();
//               },
//             ),
//           ),

//         if (_isStoryDetail && _currentStory != null)
//           CustomPageTransition(
//             child: StoryDetailScreen(
//               story: _currentStory!,
//               onBackPressed: () {
//                 _isStoryDetail = false;
//                 _currentStory = null;
//                 _currentStoryId = null;
//                 notifyListeners();
//               },
//             ),
//             key: ValueKey("StoryDetailScreen-${_currentStory!.id}"),
//             transitionType: TransitionType.fade,
//           ),

//         if (_isStoryDetailDialog && _currentStory != null)
//           DialogPage(
//             key: ValueKey('StoryDetailDialog-${_currentStory!.id}'),
//             barrierColor: Colors.black87,
//             barrierDismissible: true,
//             child: StoryDetailDialog(
//               story: _currentStory!,
//               onClose: () {
//                 _isStoryDetailDialog = false;
//                 _currentStory = null;
//                 _currentStoryId = null;
//                 notifyListeners();
//               },
//             ),
//           ),

//         if (_isLanguageDialogOpen)
//           DialogPage(
//             key: const ValueKey("LanguageDialog"),
//             barrierDismissible: true,
//             barrierColor: Colors.black54,
//             child: LanguageDialog(
//               selectedLanguageCode: settingProvider.locale.languageCode,
//               onLanguageChanged: (code) {
//                 settingProvider.setLocale(code);
//                 closeLanguageDialog();
//               },
//               onCancel: closeLanguageDialog,
//             ),
//           ),
//       ],
//       onDidRemovePage: (page) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (page.key == ValueKey("RegisterScreen")) {
//             _isRegisterScreen = false;
//             _isLoginScreen = true;
//             notifyListeners();
//           } else if (page.key.toString().startsWith(
//             "ValueKey<StoryDetailScreen-",
//           )) {
//             _isStoryDetail = false;
//             _isMainScreen = true;
//             _currentStory = null;
//             _currentStoryId = null;
//             notifyListeners();
//           } else if (page.key.toString().contains("StoryDetailScreen")) {
//             _isStoryDetail = false;
//             _isMainScreen = true;
//             notifyListeners();
//           }
//         });
//       },
//     );
//   }
// }
